Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B38E7F3F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 10:50:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B42A8F8040
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 08:50:34 -0700 (PDT)
Received: from mail-qc0-f182.google.com (mail-qc0-f182.google.com
	[209.85.216.182]) by cuda.sgi.com with ESMTP id
	MHQF2yBbRRG3iizJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 08:50:32 -0700 (PDT)
Received: by mail-qc0-f182.google.com with SMTP id x13so4563568qcv.27
	for <xfs@oss.sgi.com>; Tue, 09 Sep 2014 08:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <540F1B01.3020700@mygrande.net>
References: <540F1B01.3020700@mygrande.net>
Date: Tue, 9 Sep 2014 11:50:28 -0400
Message-ID: <CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============8228385037452418675=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8228385037452418675==
Content-Type: multipart/alternative; boundary=001a11c0b36afdf0b70502a3e41a

--001a11c0b36afdf0b70502a3e41a
Content-Type: text/plain; charset=UTF-8

Hi Leslie,

If you have a full backup, I would STRONGLY recommend just wiping your old
filesystem and restoring your backups on top of a totally fresh XFS, rather
than repairing the original filesystem and then filling in the blanks with
backups using a file-diff tool like rsync.

You will probably hear various opinions here about xfs_repair; my personal
opinion is that xfs_repair is a program made available for the unwary to
further scramble their data and make a hash of the filesystem... In my
first-hand experience managing ~7 PB of XFS storage and growing, I have
NEVER found xfs_repair (yes, even the "newest version") to ever do anything
positive. It's basically a data scrambler.

At this point, you will never achieve anything near what I'd consider a
production-grade, trustworthy data repository. Any further runs of
xfs_repair will either do nothing, or make the situation worse. Fortunately
you followed best practice and kept backups so you don't really need
xfs_repair anyway, right?

Best,

Sean

P.S. No backups? Still don't even think about running xfs_repair.
ESPECIALLY don't think about running xfs_repair. Try mounting ro; if that
doesn't work, mount ro with noreplaylog and scavenge what you can. Write
off the rest. That's the cost of doing business without backups. Running
xfs_repair (especially as a first-line step) will only make it worse, and
especially on big filesystems, the run time can extend to weeks... Don't
keep your users down any longer than you need to, running a program that
won't really help you. Just scavenge it, reformat and turn it back around.





On Tue, Sep 9, 2014 at 11:21 AM, Leslie Rhorer <lrhorer@mygrande.net> wrote:

>
> Hello,
>
>         I have an issue with my primary RAID array.  I have 13T of data on
> the array, and I suffered a major array failure.  I was able to rebuild the
> array, but some data was lost.  Of course I have backups, so after running
> xfs_repair, I ran an rsync job to recover the lost data.  Most of it was
> recovered, but there are several files that cannot be read, deleted, or
> overwritten.  I have tried running xfs_repair several times, but any
> attempt to access these files continuously reports "cannot stat XXXXXXXX:
> Structure needs cleaning".  I don't need to try to recover the data
> directly, as it does reside on the backup, but I need to clear the file
> structure so I can write the files back to the filesystem.  How do I
> proceed?
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--001a11c0b36afdf0b70502a3e41a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Leslie,<div><br></div><div>If you have a full backup, I=
 would STRONGLY recommend just wiping your old filesystem and restoring you=
r backups on top of a totally fresh XFS, rather than repairing the original=
 filesystem and then filling in the blanks with backups using a file-diff t=
ool like rsync.</div><div><br></div><div>You will probably hear various opi=
nions here about xfs_repair; my personal opinion is that xfs_repair is a pr=
ogram made available for the unwary to further scramble their data and make=
 a hash of the filesystem... In my first-hand experience managing ~7 PB of =
XFS storage and growing, I have NEVER found xfs_repair (yes, even the &quot=
;newest version&quot;) to ever do anything positive. It&#39;s basically a d=
ata scrambler.</div><div><br></div><div>At this point, you will never achie=
ve anything near what I&#39;d consider a production-grade, trustworthy data=
 repository. Any further runs of xfs_repair will either do nothing, or make=
 the situation worse. Fortunately you followed best practice and kept backu=
ps so you don&#39;t really need xfs_repair anyway, right?</div><div><br></d=
iv><div>Best,</div><div><br></div><div>Sean</div><div><br></div><div>P.S. N=
o backups? Still don&#39;t even think about running xfs_repair. ESPECIALLY =
don&#39;t think about running xfs_repair. Try mounting ro; if that doesn&#3=
9;t work, mount ro with noreplaylog and scavenge what you can. Write off th=
e rest. That&#39;s the cost of doing business without backups. Running xfs_=
repair (especially as a first-line step) will only make it worse, and espec=
ially on big filesystems, the run time can extend to weeks... Don&#39;t kee=
p your users down any longer than you need to, running a program that won&#=
39;t really help you. Just scavenge it, reformat and turn it back around.</=
div><div><br></div><div><br></div><div><br></div><div><br></div></div><div =
class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Sep 9, 2014 at=
 11:21 AM, Leslie Rhorer <span dir=3D"ltr">&lt;<a href=3D"mailto:lrhorer@my=
grande.net" target=3D"_blank">lrhorer@mygrande.net</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><br>
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

--001a11c0b36afdf0b70502a3e41a--


--===============8228385037452418675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8228385037452418675==--
