Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6SEx4cF187163 for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 09:59:05 -0500
Received: from mail-qy0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9023D140FAC7
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 07:59:49 -0700 (PDT)
Received: from mail-qy0-f173.google.com (mail-qy0-f173.google.com
	[209.85.221.173]) by cuda.sgi.com with ESMTP id
	aDJ1fh3DwaBomUAw for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2009 07:59:49 -0700 (PDT)
Received: by qyk3 with SMTP id 3so108107qyk.20
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 07:59:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6F0978.4070709@sandeen.net>
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>
	<4A6F0978.4070709@sandeen.net>
Date: Tue, 28 Jul 2009 22:59:49 +0800
Message-ID: <b094161c0907280759w6c525201vd4a17e22a8c1d582@mail.gmail.com>
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
From: Eddy Zhao <eddy.y.zhao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0292062575212006265=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

--===============0292062575212006265==
Content-Type: multipart/alternative; boundary=001636163eb574bcc2046fc55253

--001636163eb574bcc2046fc55253
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Eric:

>
> Well, the fact that you have 2 arches would have been highly relevant in
> your first email.  ;)  Is this the old abi or the new?  Guessing old,
> based on the alignment issues.
>
ARM compiler is producing eabi. The problem lies in: "long long" on arm is 8
bytes aligned, on x86 is 4 bytes aligned. So 4 more bytes are padded before
xfs_inode_log_format::ilf_ino on arm.

>
> Well, packing structures like mad is not a great solution[1] - it needs
> to be done carefully & judiciously.  We don't want to pack structures
> that are already aligned on most arches, because this will cause
> performance issues.
>

Interesting. Nice tip.

>
> But I see above you've found a few that were, for various reasons.  Note
> that the dir2 types above use a funky "__arch_pack" to conditionally
> pack only on arm old abi:
>

Get it. Thanks for the reminder.

>
> To be honest, I am not certain that this is "worth fixing" - we already
> have the requirement that log replay can only be done on an architecture
> of the same endianness, and a further requirement that it can only be
> done on architectures with similar alignment rules doesn't seem so bad.
>
Where is the official description of such requirment? The requirment is not
obvious to new XFS users, and they should be warned :)

Why is such requirment? For backward compatibility?

I think the requirment is bad. It inhibit user from exchanging data freely
between systems, which is an obvious requirment for file system design.

>
> The problem is, if you go off and "fix" this on arm now, you'll find
> that logs created under older arm kernels can't be replayed on newer arm
> kernels and vice versa...
>

Compared with the above restriction("requirment"), we can afford this :)

Do I miss any other log/metadata needs pack on 2.6.10?

Thanks
Eddy

--001636163eb574bcc2046fc55253
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>Hello Eric:</p>
<p>&gt;<br>&gt; Well, the fact that you have 2 arches would have been highl=
y relevant in<br>&gt; your first email.=A0 ;)=A0 Is this the old abi or the=
 new?=A0 Guessing old,<br>&gt; based on the alignment issues.<br>&gt;</p>
<div>ARM compiler is producing eabi. The problem lies in: &quot;long long&q=
uot; on arm is 8 bytes aligned, on x86 is 4 bytes aligned. So 4 more bytes =
are padded before xfs_inode_log_format::ilf_ino on arm.</div>
<div><br>&gt;<br>&gt; Well, packing structures like mad is not a great solu=
tion[1] - it needs<br>&gt; to be done carefully &amp; judiciously.=A0 We do=
n&#39;t want to pack structures<br>&gt; that are already aligned on most ar=
ches, because this will cause<br>
&gt; performance issues.<br>&gt;</div>
<p>Interesting. Nice tip.</p>
<p>&gt;<br>&gt; But I see above you&#39;ve found a few that were, for vario=
us reasons.=A0 Note<br>&gt; that the dir2 types above use a funky &quot;__a=
rch_pack&quot; to conditionally<br>&gt; pack only on arm old abi:<br>&gt;</=
p>

<p>Get it. Thanks for the reminder.</p>
<p>&gt; <br>&gt; To be honest, I am not certain that this is &quot;worth fi=
xing&quot; - we already<br>&gt; have the requirement that log replay can on=
ly be done on an architecture<br>&gt; of the same endianness, and a further=
 requirement that it can only be<br>
&gt; done on architectures with similar alignment rules doesn&#39;t seem so=
 bad.<br>&gt;</p>
<div>Where is the official description of such requirment? The requirment i=
s not obvious to new XFS users, and they should be warned :)</div>
<div><br>Why is such requirment? For backward compatibility?</div>
<div><br>I think the requirment is bad. It inhibit user from=A0exchanging d=
ata freely between systems, which is an obvious requirment for file system =
design.</div>
<p>&gt;<br>&gt; The problem is, if you go off and &quot;fix&quot; this on a=
rm now, you&#39;ll find<br>&gt; that logs created under older arm kernels c=
an&#39;t be replayed on newer arm<br>&gt; kernels and vice versa...<br>
&gt;</p>
<p>Compared with the above restriction(&quot;requirment&quot;), we can affo=
rd this :)</p>
<p>Do I miss any other log/metadata needs pack on 2.6.10? </p>
<p>Thanks<br>Eddy</p>

--001636163eb574bcc2046fc55253--


--===============0292062575212006265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0292062575212006265==--
