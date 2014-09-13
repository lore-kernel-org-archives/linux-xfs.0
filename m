Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 640057F47
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 12:07:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3AAFB8F804B
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 10:07:56 -0700 (PDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	uGCxBpAQc81BRUst (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 10:07:54 -0700 (PDT)
Received: by mail-ie0-f170.google.com with SMTP id tp5so2628331ieb.29
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 10:07:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 13 Sep 2014 22:37:53 +0530
Message-ID: <CAJAKVEFGf5yKBy7BK3K9fRW3DZpZ1+1-bvnzpVpPdpB219Amtw@mail.gmail.com>
Subject: [RFD] xfs_fsr: Doubts related to xfs_fsr code
From: Somdeep Dey <somdeepdey10@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6503212041451765132=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6503212041451765132==
Content-Type: multipart/alternative; boundary=90e6ba6e8fb83e236d0502f57163

--90e6ba6e8fb83e236d0502f57163
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

While studying the code and attempting to understand it, we have come up
against certain doubts that have us in a slight fix. We've included the
concerned
 sections of the code below, along with our specific problem in each of
these
 sections. A little pointer in the right direction would be of great help.

(Source file : fsr_xfs_fsr.c)

****** Doubt number 1 ******
(line 331 onwards)
int main()

if (optind < argc) // If the command line input contains the XFS
//filesystem name / file on which xfs_fsr needs to be run on
{
for (; optind < argc; optind++)
{
argname =3D argv[optind]; // save target which can be file or filesystem
if (lstat64(argname, &sb) < 0)
{ /* This system call returns a stat64 structure, and thus sets
                * all fields in it.
* On success, zero is returned.  On error, -1 is returned,
                * and  errno  is set appropriately.
*/
fprintf(stderr,
_("%s: could not stat: %s: %s\n"),
progname, argname, strerror(errno));
continue;
}
// POSIX macros are defined to check the file type using the st_mode field
if (S_ISLNK(sb.st_mode)) // Check if path(argname) is a
//symbolic link, if so link will be stat-ed and not file
{// Hence  we run stat64() and save the obtained stat structure
struct stat64 sb2;
if (stat64(argname, &sb2) =3D=3D 0 && (S_ISBLK(sb2.st_mode) ||
     S_ISCHR(sb2.st_mode)))
sb =3D sb2; // check if stat is a success and
//if argname(path) is block device ? OR is character device?
}
___________________________________________________________________________=
_____

We understand that lstat64() and stat64() are used to see if target
 (file/filesystem) can be stated and if yes then the structure is saved.
But we couldn=E2=80=99t exactly understand its use and why both functions a=
re used
separately.
Usually the error could not stat: filename : is followed by Permission
denied.
 Is this related to the root permissions i.e. accessibility ?

****** Doubt number 2 ******

(line 184 onwards)
static char *
find_mountpoint(char *mtab, char *argname, struct stat64 *sb)

while ((t =3D getmntent(mtabp))) {
if (S_ISDIR(sb->st_mode)) { /* mount point */
if (stat64(t->mnt_dir, &ms) < 0)
continue;
if (sb->st_ino !=3D ms.st_ino)
continue;
if (sb->st_dev !=3D ms.st_dev)
continue;
if (strcmp(t->mnt_type, MNTTYPE_XFS) !=3D 0)
continue;
} else { /* device */
struct stat64 sb2;

if (stat64(t->mnt_fsname, &ms) < 0)
continue;
if (sb->st_rdev !=3D ms.st_rdev)
continue;
if (strcmp(t->mnt_type, MNTTYPE_XFS) !=3D 0)
continue;

/*
 * Make sure the mount point given by mtab is accessible
 * before using it.
 */
if (stat64(t->mnt_dir, &sb2) < 0)
continue;
}
___________________________________________________________________________=
_____
We just wanted to confirm if the basic working of the function is
1) To obtain a mount table pointer to the mount table (/etc/mtab/ or
/proc/mounts).
2)  For each entry in the mount table check if it is a directory or device
and after
 performing various comparisons (checks) =E2=80=93 (could you please elabor=
ate on
the checks
  performed), this function returns a pointer to the entry.

****** Doubt number 3 ******

(line 677 onwards)
static int
fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)

For the following

__s32 buflenout;

fshandlep =3D jdm_getfshandle( mntdir );
if ( ! fshandlep ) {
fsrprintf(_("unable to get handle: %s: %s\n"),
          mntdir, strerror( errno ));
return -1;
}
___________________________________________________________________________=
_____

We are a bit confused about what is exactly the file handle being returned
 by jdm_getfshandle().
Also what exactly is buflenout. Is it a structure field ?
___________________________________________________________________________=
_____

while ((ret =3D xfs_bulkstat(fsfd,&lastino, GRABSZ, &buf[0], &buflenout) =
=3D=3D
0))
 {
xfs_bstat_t *p;
xfs_bstat_t *endp;

if (buflenout =3D=3D 0)
goto out0;

/* Each loop through, defrag targetrange percent of the files */
count =3D (buflenout * targetrange) / 100;

qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp);
___________________________________________________________________________=
_____

In the above code snippet we understand that the while loop will run for
N(10)
passes and defragment top 10% of the defragmented files.
However we would appreciate if you could further explain the functions:

(ret =3D xfs_bulkstat(fsfd,&lastino, GRABSZ, &buf[0], &buflenout) =3D=3D 0)

qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp);

We know that the sort function will be used to sort extents based on size
and then
offset, but a bit more information on how it is exactly working will be
really
appreciated, as we believe that this sort() has some other purpose.
___________________________________________________________________________=
_____



For this mail we have listed only a limited number of doubts that we think
are pressing. Based on further explanations that we might receive from you,
we will send out another  mail for the doubts that still linger.

Regards,
A-DRS.

--90e6ba6e8fb83e236d0502f57163
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_extra">Hi,<=
/div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">While =
studying the code and attempting to understand it, we have come up against =
certain doubts that have us in a slight fix. We&#39;ve included the concern=
ed</div><div class=3D"gmail_extra">=C2=A0sections of the code below, along =
with our specific problem in each of these=C2=A0</div><div class=3D"gmail_e=
xtra">=C2=A0sections. A little pointer in the right direction would be of g=
reat help.</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_ex=
tra">(Source file : fsr_xfs_fsr.c)</div><div class=3D"gmail_extra"><br></di=
v><div class=3D"gmail_extra">****** Doubt number 1 ******</div><div class=
=3D"gmail_extra">(line 331 onwards)</div><div class=3D"gmail_extra">int mai=
n()=C2=A0</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_ext=
ra">if (optind &lt; argc)<span class=3D"" style=3D"white-space:pre">	</span=
>// If the command line input contains the XFS=C2=A0</div><div class=3D"gma=
il_extra">//filesystem name / file on which xfs_fsr needs to be run on</div=
><div class=3D"gmail_extra">{<span class=3D"" style=3D"white-space:pre">	</=
span></div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space=
:pre">	</span>for (; optind &lt; argc; optind++)=C2=A0</div><div class=3D"g=
mail_extra"><span class=3D"" style=3D"white-space:pre">	</span>{</div><div =
class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">		</span>a=
rgname =3D argv[optind];<span class=3D"" style=3D"white-space:pre">	</span>=
// save target which can be file or filesystem<span class=3D"" style=3D"whi=
te-space:pre">	</span></div><div class=3D"gmail_extra"><span class=3D"" sty=
le=3D"white-space:pre">		</span>if (lstat64(argname, &amp;sb) &lt; 0) <span=
 class=3D"" style=3D"white-space:pre">	</span></div><div class=3D"gmail_ext=
ra"><span class=3D"" style=3D"white-space:pre">		</span>{<span class=3D"" s=
tyle=3D"white-space:pre">	</span>/* This system call returns a stat64 struc=
ture, and thus sets =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0</div><div class=3D"g=
mail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * all f=
ields in it.</div><div class=3D"gmail_extra"><span class=3D"" style=3D"whit=
e-space:pre">				</span>* On success, zero is returned. =C2=A0On error, -1 =
is returned,=C2=A0</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * and =C2=A0errno =C2=A0is set appropriatel=
y.</div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pr=
e">			</span>*/</div><div class=3D"gmail_extra"><span class=3D"" style=3D"w=
hite-space:pre">			</span>fprintf(stderr,</div><div class=3D"gmail_extra"><=
span class=3D"" style=3D"white-space:pre">			</span>_(&quot;%s: could not s=
tat: %s: %s\n&quot;),</div><div class=3D"gmail_extra"><span class=3D"" styl=
e=3D"white-space:pre">			</span>progname, argname, strerror(errno));</div><=
div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">			</s=
pan>continue;<span class=3D"" style=3D"white-space:pre">	</span></div><div =
class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">		</span>}=
</div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre"=
>		</span>// POSIX macros are defined to check the file type using the st_m=
ode field</div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-s=
pace:pre">		</span>if (S_ISLNK(sb.st_mode)) <span class=3D"" style=3D"white=
-space:pre">	</span>// Check if path(argname) is a=C2=A0</div><div class=3D=
"gmail_extra"><span class=3D"" style=3D"white-space:pre">		</span>//symboli=
c link, if so link will be stat-ed and not file</div><div class=3D"gmail_ex=
tra"><span class=3D"" style=3D"white-space:pre">		</span>{// Hence =C2=A0we=
 run stat64() and save the obtained stat structure</div><div class=3D"gmail=
_extra"><span class=3D"" style=3D"white-space:pre">			</span>struct stat64 =
sb2;</div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:=
pre">			</span>if (stat64(argname, &amp;sb2) =3D=3D 0 &amp;&amp; (S_ISBLK(s=
b2.st_mode) ||<span class=3D"" style=3D"white-space:pre">									</span> =
=C2=A0=C2=A0</div><div class=3D"gmail_extra"><span class=3D"" style=3D"whit=
e-space:pre">			</span> =C2=A0 =C2=A0 S_ISCHR(sb2.st_mode)))</div><div clas=
s=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">					</span>sb=
 =3D sb2;<span class=3D"" style=3D"white-space:pre">	</span>// check if sta=
t is a success and=C2=A0</div><div class=3D"gmail_extra"><span class=3D"" s=
tyle=3D"white-space:pre">					</span>//if argname(path) is block device ? O=
R is character device? <span class=3D"" style=3D"white-space:pre">	</span><=
/div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">=
		</span>}</div><div class=3D"gmail_extra">________________________________=
________________________________________________</div><div class=3D"gmail_e=
xtra"><br></div><div class=3D"gmail_extra">We understand that lstat64() and=
 stat64() are used to see if target</div><div class=3D"gmail_extra">=C2=A0(=
file/filesystem) can be stated and if yes then the structure is saved.=C2=
=A0</div><div class=3D"gmail_extra">But we couldn=E2=80=99t exactly underst=
and its use and why both functions are used separately.</div><div class=3D"=
gmail_extra">Usually the error could not stat: filename : is followed by Pe=
rmission denied.</div><div class=3D"gmail_extra">=C2=A0Is this related to t=
he root permissions i.e. accessibility ?</div><div class=3D"gmail_extra"><b=
r></div><div class=3D"gmail_extra">****** Doubt number 2 ******</div><div c=
lass=3D"gmail_extra"><br></div><div class=3D"gmail_extra">(line 184 onwards=
)</div><div class=3D"gmail_extra">static char *</div><div class=3D"gmail_ex=
tra">find_mountpoint(char *mtab, char *argname, struct stat64 *sb)</div><di=
v class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">while ((t =3D =
getmntent(mtabp))) {</div><div class=3D"gmail_extra"><span class=3D"" style=
=3D"white-space:pre">		</span>if (S_ISDIR(sb-&gt;st_mode)) {<span class=3D"=
" style=3D"white-space:pre">		</span>/* mount point */</div><div class=3D"g=
mail_extra"><span class=3D"" style=3D"white-space:pre">			</span>if (stat64=
(t-&gt;mnt_dir, &amp;ms) &lt; 0)</div><div class=3D"gmail_extra"><span clas=
s=3D"" style=3D"white-space:pre">				</span>continue;</div><div class=3D"gm=
ail_extra"><span class=3D"" style=3D"white-space:pre">			</span>if (sb-&gt;=
st_ino !=3D ms.st_ino)</div><div class=3D"gmail_extra"><span class=3D"" sty=
le=3D"white-space:pre">				</span>continue;</div><div class=3D"gmail_extra"=
><span class=3D"" style=3D"white-space:pre">			</span>if (sb-&gt;st_dev !=
=3D ms.st_dev)</div><div class=3D"gmail_extra"><span class=3D"" style=3D"wh=
ite-space:pre">				</span>continue;</div><div class=3D"gmail_extra"><span c=
lass=3D"" style=3D"white-space:pre">			</span>if (strcmp(t-&gt;mnt_type, MN=
TTYPE_XFS) !=3D 0)</div><div class=3D"gmail_extra"><span class=3D"" style=
=3D"white-space:pre">				</span>continue;</div><div class=3D"gmail_extra"><=
span class=3D"" style=3D"white-space:pre">		</span>} else {<span class=3D""=
 style=3D"white-space:pre">				</span>/* device */</div><div class=3D"gmail=
_extra"><span class=3D"" style=3D"white-space:pre">			</span>struct stat64 =
sb2;</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><=
span class=3D"" style=3D"white-space:pre">			</span>if (stat64(t-&gt;mnt_fs=
name, &amp;ms) &lt; 0)</div><div class=3D"gmail_extra"><span class=3D"" sty=
le=3D"white-space:pre">				</span>continue;</div><div class=3D"gmail_extra"=
><span class=3D"" style=3D"white-space:pre">			</span>if (sb-&gt;st_rdev !=
=3D ms.st_rdev)</div><div class=3D"gmail_extra"><span class=3D"" style=3D"w=
hite-space:pre">				</span>continue;</div><div class=3D"gmail_extra"><span =
class=3D"" style=3D"white-space:pre">			</span>if (strcmp(t-&gt;mnt_type, M=
NTTYPE_XFS) !=3D 0)</div><div class=3D"gmail_extra"><span class=3D"" style=
=3D"white-space:pre">				</span>continue;</div><div class=3D"gmail_extra"><=
br></div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:p=
re">			</span>/*</div><div class=3D"gmail_extra"><span class=3D"" style=3D"=
white-space:pre">			</span> * Make sure the mount point given by mtab is ac=
cessible</div><div class=3D"gmail_extra"><span class=3D"" style=3D"white-sp=
ace:pre">			</span> * before using it.</div><div class=3D"gmail_extra"><spa=
n class=3D"" style=3D"white-space:pre">			</span> */</div><div class=3D"gma=
il_extra"><span class=3D"" style=3D"white-space:pre">			</span>if (stat64(t=
-&gt;mnt_dir, &amp;sb2) &lt; 0)</div><div class=3D"gmail_extra"><span class=
=3D"" style=3D"white-space:pre">				</span>continue;</div><div class=3D"gma=
il_extra"><span class=3D"" style=3D"white-space:pre">		</span>}</div><div c=
lass=3D"gmail_extra">______________________________________________________=
__________________________</div><div class=3D"gmail_extra">We just wanted t=
o confirm if the basic working of the function is</div><div class=3D"gmail_=
extra">1) To obtain a mount table pointer to the mount table (/etc/mtab/ or=
 /proc/mounts).</div><div class=3D"gmail_extra">2) =C2=A0For each entry in =
the mount table check if it is a directory or device and after</div><div cl=
ass=3D"gmail_extra">=C2=A0performing various comparisons (checks) =E2=80=93=
 (could you please elaborate on the checks</div><div class=3D"gmail_extra">=
=C2=A0 performed), this function returns a pointer to the entry.=C2=A0</div=
><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">****** Dou=
bt number 3 ******</div><div class=3D"gmail_extra"><br></div><div class=3D"=
gmail_extra">(line 677 onwards)</div><div class=3D"gmail_extra">static int<=
/div><div class=3D"gmail_extra">fsrfs(char *mntdir, xfs_ino_t startino, int=
 targetrange)</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail=
_extra">For the following=C2=A0</div><div class=3D"gmail_extra"><br></div><=
div class=3D"gmail_extra">__s32<span class=3D"" style=3D"white-space:pre">	=
</span>buflenout;</div><div class=3D"gmail_extra"><br></div><div class=3D"g=
mail_extra"><span class=3D"" style=3D"white-space:pre">	</span>fshandlep =
=3D jdm_getfshandle( mntdir );</div><div class=3D"gmail_extra"><span class=
=3D"" style=3D"white-space:pre">	</span>if ( ! fshandlep ) {</div><div clas=
s=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">		</span>fsrpr=
intf(_(&quot;unable to get handle: %s: %s\n&quot;),</div><div class=3D"gmai=
l_extra"><span class=3D"" style=3D"white-space:pre">		</span> =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0mntdir, strerror( errno ));</div><div class=3D"gmail_e=
xtra"><span class=3D"" style=3D"white-space:pre">		</span>return -1;</div><=
div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">	</spa=
n>}</div><div class=3D"gmail_extra">_______________________________________=
_________________________________________</div><div class=3D"gmail_extra"><=
br></div><div class=3D"gmail_extra">We are a bit confused about what is exa=
ctly the file handle being returned</div><div class=3D"gmail_extra">=C2=A0b=
y jdm_getfshandle().</div><div class=3D"gmail_extra">Also what exactly is b=
uflenout. Is it a structure field ?</div><div class=3D"gmail_extra">_______=
_________________________________________________________________________</=
div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">while (=
(ret =3D xfs_bulkstat(fsfd,&amp;lastino, GRABSZ, &amp;buf[0], &amp;buflenou=
t) =3D=3D 0))</div><div class=3D"gmail_extra"><span class=3D"" style=3D"whi=
te-space:pre">	</span> {</div><div class=3D"gmail_extra"><span class=3D"" s=
tyle=3D"white-space:pre">		</span>xfs_bstat_t *p;</div><div class=3D"gmail_=
extra"><span class=3D"" style=3D"white-space:pre">		</span>xfs_bstat_t *end=
p;</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><sp=
an class=3D"" style=3D"white-space:pre">		</span>if (buflenout =3D=3D 0)</d=
iv><div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">		=
	</span>goto out0;</div><div class=3D"gmail_extra"><br></div><div class=3D"=
gmail_extra"><span class=3D"" style=3D"white-space:pre">		</span>/* Each lo=
op through, defrag targetrange percent of the files */</div><div class=3D"g=
mail_extra"><span class=3D"" style=3D"white-space:pre">		</span>count =3D (=
buflenout * targetrange) / 100;</div><div class=3D"gmail_extra"><br></div><=
div class=3D"gmail_extra"><span class=3D"" style=3D"white-space:pre">		</sp=
an>qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp);</div><div =
class=3D"gmail_extra">_____________________________________________________=
___________________________</div><div class=3D"gmail_extra"><br></div><div =
class=3D"gmail_extra">In the above code snippet we understand that the whil=
e loop will run for N(10)=C2=A0</div><div class=3D"gmail_extra">passes and =
defragment top 10% of the defragmented files.</div><div class=3D"gmail_extr=
a">However we would appreciate if you could further explain the functions:<=
/div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">(ret =
=3D xfs_bulkstat(fsfd,&amp;lastino, GRABSZ, &amp;buf[0], &amp;buflenout) =
=3D=3D 0)</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_ext=
ra">qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp);</div><div=
 class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">We know that th=
e sort function will be used to sort extents based on size and then=C2=A0</=
div><div class=3D"gmail_extra">offset, but a bit more information on how it=
 is exactly working will be really=C2=A0</div><div class=3D"gmail_extra">ap=
preciated, as we believe that this sort() has some other purpose.</div><div=
 class=3D"gmail_extra">____________________________________________________=
____________________________</div><div class=3D"gmail_extra"><br></div><div=
 class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><br></div><div =
class=3D"gmail_extra">For this mail we have listed only a limited number of=
 doubts that we think are pressing. Based on further explanations that we m=
ight receive from you, we will send out another =C2=A0mail for the doubts t=
hat still linger.</div><div class=3D"gmail_extra"><br></div><div class=3D"g=
mail_extra">Regards,</div><div class=3D"gmail_extra">A-DRS.</div></div></di=
v>

--90e6ba6e8fb83e236d0502f57163--


--===============6503212041451765132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6503212041451765132==--
