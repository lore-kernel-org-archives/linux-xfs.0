Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2B5D29E32
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:11:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6640304062
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:11:57 -0700 (PDT)
Received: from mail-vb0-f54.google.com (mail-vb0-f54.google.com
	[209.85.212.54]) by cuda.sgi.com with ESMTP id zQW6AoHXYZT5HnLY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:11:56 -0700 (PDT)
Received: by mail-vb0-f54.google.com with SMTP id q16so1534530vbe.41
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:11:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
	<20130726205018.GM3111@sgi.com>
	<CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
Date: Fri, 26 Jul 2013 17:11:55 -0400
Message-ID: <CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
Subject: Re: understanding speculative preallocation
From: Jason Rosenberg <jbr@squareup.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6481987163047745571=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

--===============6481987163047745571==
Content-Type: multipart/alternative; boundary=089e01536dc4b09c9604e27097ef

--089e01536dc4b09c9604e27097ef
Content-Type: text/plain; charset=ISO-8859-1

Is it safe to say that speculative preallocation will not be used if a file
is opened read-only?

It turns out that the kafka server does indeed write lots of log files, and
rotate them after they reach a max size, but never closes the files until
the app exits, or until it deletes the files.  This is because it needs to
make them available for reading, etc.   So, an obvious change for kafka
might be to close each log file after rotating, and then re-open it
read-only for consumers of the data.  Does that sound like a solution that
would pro-actively release pre-allocated storage?

Thanks,

Jason


On Fri, Jul 26, 2013 at 5:04 PM, Jason Rosenberg <jbr@squareup.com> wrote:

> Thanks Ben,
>
> This is helpful.
>
>
> On Fri, Jul 26, 2013 at 4:50 PM, Ben Myers <bpm@sgi.com> wrote:
>
>> Hi Jason,
>>
>> On Fri, Jul 26, 2013 at 04:38:21PM -0400, Jason Rosenberg wrote:
>> > Thanks for the info (most of it was, in fact, news to me).  I'm an
>> > application developer trying to debug a disk space problem, that's all.
>>  So
>> > far, I've tracked it down to being an XFS issue.
>>
>> The speculative block reservations have been an issue for awhile.  You
>> are not
>> the first person to take issue with it.
>>
>> > Regardless, is there a version history for XFS vis-a-via mainline Linux?
>>
>> You can find a full version history for XFS back to 2.6.12 or so here:
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=summary
>>
>> If you're interested in going older than that look here:
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=summary
>>
>> The function you'll most likely want to track is xfs_iomap_write_delay,
>> which
>> calls xfs_iomap_eof_want_preallocate, both of which are in
>> fs/xfs/xfs_iomap.c.
>>
>> Recently Brian Foster added a scanner to remove the speculative block
>> reservations on a timer which may give you some relief.  See
>> xfs_queue_eofblocks in fs/xfs/xfs_icache.c
>>
>> Regards,
>>         Ben
>>
>>
>

--089e01536dc4b09c9604e27097ef
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Is it safe to say that speculative preallocation will not =
be used if a file is opened read-only?<div><br></div><div>It turns out that=
 the kafka server does indeed write lots of log files, and rotate them afte=
r they reach a max size, but never closes the files until the app exits, or=
 until it deletes the files. =A0This is because it needs to make them avail=
able for reading, etc. =A0 So, an obvious change for kafka might be to clos=
e each log file after rotating, and then re-open it read-only for consumers=
 of the data. =A0Does that sound like a solution that would pro-actively re=
lease pre-allocated storage?</div>
<div><br></div><div>Thanks,</div><div><br></div><div>Jason</div></div><div =
class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Jul 26, 20=
13 at 5:04 PM, Jason Rosenberg <span dir=3D"ltr">&lt;<a href=3D"mailto:jbr@=
squareup.com" target=3D"_blank">jbr@squareup.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Thanks Ben,<div><br></div><=
div>This is helpful.</div></div><div class=3D"HOEnZb"><div class=3D"h5"><di=
v class=3D"gmail_extra">
<br><br><div class=3D"gmail_quote">On Fri, Jul 26, 2013 at 4:50 PM, Ben Mye=
rs <span dir=3D"ltr">&lt;<a href=3D"mailto:bpm@sgi.com" target=3D"_blank">b=
pm@sgi.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi Jason,<br>
<div><br>
On Fri, Jul 26, 2013 at 04:38:21PM -0400, Jason Rosenberg wrote:<br>
&gt; Thanks for the info (most of it was, in fact, news to me). =A0I&#39;m =
an<br>
&gt; application developer trying to debug a disk space problem, that&#39;s=
 all. =A0So<br>
&gt; far, I&#39;ve tracked it down to being an XFS issue.<br>
<br>
</div>The speculative block reservations have been an issue for awhile. =A0=
You are not<br>
the first person to take issue with it.<br>
<div><br>
&gt; Regardless, is there a version history for XFS vis-a-via mainline Linu=
x?<br>
<br>
</div>You can find a full version history for XFS back to 2.6.12 or so here=
:<br>
<a href=3D"http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/xfs.git;a=3Dsummar=
y" target=3D"_blank">http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/xfs.git;=
a=3Dsummary</a><br>
<br>
If you&#39;re interested in going older than that look here:<br>
<a href=3D"http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Darchive/xfs-import.git=
;a=3Dsummary" target=3D"_blank">http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Da=
rchive/xfs-import.git;a=3Dsummary</a><br>
<br>
The function you&#39;ll most likely want to track is xfs_iomap_write_delay,=
 which<br>
calls xfs_iomap_eof_want_preallocate, both of which are in fs/xfs/xfs_iomap=
.c.<br>
<br>
Recently Brian Foster added a scanner to remove the speculative block<br>
reservations on a timer which may give you some relief. =A0See<br>
xfs_queue_eofblocks in fs/xfs/xfs_icache.c<br>
<br>
Regards,<br>
=A0 =A0 =A0 =A0 Ben<br>
<br>
</blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--089e01536dc4b09c9604e27097ef--


--===============6481987163047745571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6481987163047745571==--
