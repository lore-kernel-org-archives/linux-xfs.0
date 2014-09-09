Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07FD47F3F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 11:04:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66A54AC003
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 09:04:01 -0700 (PDT)
Received: from mail-qc0-f178.google.com (mail-qc0-f178.google.com
	[209.85.216.178]) by cuda.sgi.com with ESMTP id
	YyqEJqwJ5g15dRGx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 09:03:59 -0700 (PDT)
Received: by mail-qc0-f178.google.com with SMTP id x13so17476707qcv.37
	for <xfs@oss.sgi.com>; Tue, 09 Sep 2014 09:03:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
References: <540F1B01.3020700@mygrande.net>
	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
Date: Tue, 9 Sep 2014 12:03:56 -0400
Message-ID: <CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
Subject: Re: Corrupted files
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4354934889453151968=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4354934889453151968==
Content-Type: multipart/alternative; boundary=089e0149c46e2367870502a41522

--089e0149c46e2367870502a41522
Content-Type: text/plain; charset=UTF-8

OK, let me retract just a tiny fraction of what I said originally; thinking
about it further, there was _one_ time I was able to use xfs_repair to
successfully recover a "lightly bruised" XFS and return it to service. But
in that case, the fault was very minor and I always check first with:

xfs_repair [-L] -n -v <filesystem>

and give the output a good looking over before proceeding further.

If it won't run without zeroing the log, you can take that as a sign that
things are getting dire.. I wouldn't bother to run xfs_repair "for real" if
the trial output looked even slightly non-trivial, in cases of underlying
array failure or massive filesystem corruption, and I'd never run it
without mounting and scavenging first (unless I had a very recent full
backup). Barring rare cases, xfs_repair is bad juju.

Best,

Sean






On Tue, Sep 9, 2014 at 11:50 AM, Sean Caron <scaron@umich.edu> wrote:

> Hi Leslie,
>
> If you have a full backup, I would STRONGLY recommend just wiping your old
> filesystem and restoring your backups on top of a totally fresh XFS, rather
> than repairing the original filesystem and then filling in the blanks with
> backups using a file-diff tool like rsync.
>
> You will probably hear various opinions here about xfs_repair; my personal
> opinion is that xfs_repair is a program made available for the unwary to
> further scramble their data and make a hash of the filesystem... In my
> first-hand experience managing ~7 PB of XFS storage and growing, I have
> NEVER found xfs_repair (yes, even the "newest version") to ever do anything
> positive. It's basically a data scrambler.
>
> At this point, you will never achieve anything near what I'd consider a
> production-grade, trustworthy data repository. Any further runs of
> xfs_repair will either do nothing, or make the situation worse. Fortunately
> you followed best practice and kept backups so you don't really need
> xfs_repair anyway, right?
>
> Best,
>
> Sean
>
> P.S. No backups? Still don't even think about running xfs_repair.
> ESPECIALLY don't think about running xfs_repair. Try mounting ro; if that
> doesn't work, mount ro with noreplaylog and scavenge what you can. Write
> off the rest. That's the cost of doing business without backups. Running
> xfs_repair (especially as a first-line step) will only make it worse, and
> especially on big filesystems, the run time can extend to weeks... Don't
> keep your users down any longer than you need to, running a program that
> won't really help you. Just scavenge it, reformat and turn it back around.
>
>
>
>
>
> On Tue, Sep 9, 2014 at 11:21 AM, Leslie Rhorer <lrhorer@mygrande.net>
> wrote:
>
>>
>> Hello,
>>
>>         I have an issue with my primary RAID array.  I have 13T of data
>> on the array, and I suffered a major array failure.  I was able to rebuild
>> the array, but some data was lost.  Of course I have backups, so after
>> running xfs_repair, I ran an rsync job to recover the lost data.  Most of
>> it was recovered, but there are several files that cannot be read, deleted,
>> or overwritten.  I have tried running xfs_repair several times, but any
>> attempt to access these files continuously reports "cannot stat XXXXXXXX:
>> Structure needs cleaning".  I don't need to try to recover the data
>> directly, as it does reside on the backup, but I need to clear the file
>> structure so I can write the files back to the filesystem.  How do I
>> proceed?
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>

--089e0149c46e2367870502a41522
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">OK, let me retract just a tiny fraction of what I said ori=
ginally; thinking about it further, there was _one_ time I was able to use =
xfs_repair to successfully recover a &quot;lightly bruised&quot; XFS and re=
turn it to service. But in that case, the fault was very minor and I always=
 check first with:<div><br></div><div>xfs_repair [-L] -n -v &lt;filesystem&=
gt;</div><div><br></div><div>and give the output a good looking over before=
 proceeding further.</div><div><br></div><div>If it won&#39;t run without z=
eroing the log, you can take that as a sign that things are getting dire.. =
I wouldn&#39;t bother to run xfs_repair &quot;for real&quot; if the trial o=
utput looked even slightly non-trivial, in cases of underlying array failur=
e or massive filesystem corruption, and I&#39;d never run it without mounti=
ng and scavenging first (unless I had a very recent full backup). Barring r=
are cases, xfs_repair is bad juju.</div><div><br></div><div>Best,</div><div=
><br></div><div>Sean</div><div><br></div><div><br></div><div><br></div><div=
><br></div><div><br></div></div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Tue, Sep 9, 2014 at 11:50 AM, Sean Caron <span dir=3D"l=
tr">&lt;<a href=3D"mailto:scaron@umich.edu" target=3D"_blank">scaron@umich.=
edu</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr=
">Hi Leslie,<div><br></div><div>If you have a full backup, I would STRONGLY=
 recommend just wiping your old filesystem and restoring your backups on to=
p of a totally fresh XFS, rather than repairing the original filesystem and=
 then filling in the blanks with backups using a file-diff tool like rsync.=
</div><div><br></div><div>You will probably hear various opinions here abou=
t xfs_repair; my personal opinion is that xfs_repair is a program made avai=
lable for the unwary to further scramble their data and make a hash of the =
filesystem... In my first-hand experience managing ~7 PB of XFS storage and=
 growing, I have NEVER found xfs_repair (yes, even the &quot;newest version=
&quot;) to ever do anything positive. It&#39;s basically a data scrambler.<=
/div><div><br></div><div>At this point, you will never achieve anything nea=
r what I&#39;d consider a production-grade, trustworthy data repository. An=
y further runs of xfs_repair will either do nothing, or make the situation =
worse. Fortunately you followed best practice and kept backups so you don&#=
39;t really need xfs_repair anyway, right?</div><div><br></div><div>Best,</=
div><div><br></div><div>Sean</div><div><br></div><div>P.S. No backups? Stil=
l don&#39;t even think about running xfs_repair. ESPECIALLY don&#39;t think=
 about running xfs_repair. Try mounting ro; if that doesn&#39;t work, mount=
 ro with noreplaylog and scavenge what you can. Write off the rest. That&#3=
9;s the cost of doing business without backups. Running xfs_repair (especia=
lly as a first-line step) will only make it worse, and especially on big fi=
lesystems, the run time can extend to weeks... Don&#39;t keep your users do=
wn any longer than you need to, running a program that won&#39;t really hel=
p you. Just scavenge it, reformat and turn it back around.</div><div><br></=
div><div><br></div><div><br></div><div><br></div></div><div class=3D"HOEnZb=
"><div class=3D"h5"><div class=3D"gmail_extra"><br><div class=3D"gmail_quot=
e">On Tue, Sep 9, 2014 at 11:21 AM, Leslie Rhorer <span dir=3D"ltr">&lt;<a =
href=3D"mailto:lrhorer@mygrande.net" target=3D"_blank">lrhorer@mygrande.net=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><br>
Hello,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I have an issue with my primary RAID array.=C2=
=A0 I have 13T of data on the array, and I suffered a major array failure.=
=C2=A0 I was able to rebuild the array, but some data was lost.=C2=A0 Of co=
urse I have backups, so after running xfs_repair, I ran an rsync job to rec=
over the lost data.=C2=A0 Most of it was recovered, but there are several f=
iles that cannot be read, deleted, or overwritten.=C2=A0 I have tried runni=
ng xfs_repair several times, but any attempt to access these files continuo=
usly reports &quot;cannot stat XXXXXXXX: Structure needs cleaning&quot;.=C2=
=A0 I don&#39;t need to try to recover the data directly, as it does reside=
 on the backup, but I need to clear the file structure so I can write the f=
iles back to the filesystem.=C2=A0 How do I proceed?<br>
<br>
______________________________<u></u>_________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/<u></u>listinfo/xfs</a><br>
</blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--089e0149c46e2367870502a41522--


--===============4354934889453151968==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4354934889453151968==--
