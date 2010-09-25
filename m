Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PHD9Y9242797 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 12:13:10 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12F1E14FDF53
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 10:26:51 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	0HZQHF9Qti5EpZ8f for <xfs@oss.sgi.com>;
	Sat, 25 Sep 2010 10:26:51 -0700 (PDT)
Received: by iwn39 with SMTP id 39so3201320iwn.26
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 10:14:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100925170103.GA2422@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<4C9C875D.9050308@open-e.com>
	<20100925155611.GA21928@infradead.org>
	<AANLkTik=wkAkbexmO+4WCCT2pusRu-DTq1=yNwv9V5f0@mail.gmail.com>
	<20100925170103.GA2422@infradead.org>
Date: Sat, 25 Sep 2010 10:14:05 -0700
Message-ID: <AANLkTinBKsFqpowm+JnLLLEn3X-O5PDgv8p8GdASbe7Z@mail.gmail.com>
Subject: Re: Problem with file system on iSCSI FileIO
From: Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>, xfs@oss.sgi.com

On Sat, Sep 25, 2010 at 10:01 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
> On Sat, Sep 25, 2010 at 09:54:46AM -0700, Richard Sharpe wrote:
>> fileio uses submit_bio to submit the data and it defaults to
>> WRITE_THROUGH, NV_CACHE and DIRECT_IO (at least in the trunk, but I
>> suspect this has been the case for a long while) however, the person
>> making the complaint might have switched off WRITE_THROUGH in the
>> pursuit of performance, in which case a crash could corrupt things
>> badly but it would depend on whether or not clearing WRITE_THROUGH
>> also clears NV_CACHE and what the code assembling the caching mode
>> page does (and I have only had a cursory glance at the vdisk code).
>
> If the target uses submit_bio for logical files inside a filesystems
> there are hundreds of ways to get exactly the corruption that Slawomir
> sees. =A0How does it obtain the logical to physical mapping? =A0What lock=
ing
> does it use agains other access to the file?

Actually, I was wrong. for fileio it does vfs_writev. I started
wondering the same questions and went back through the code and
noticed that I had missed a test.

We really need to know what parameters the person making the complaint
is using, and the version of SCST.

In addition, I don't understand when this corruption occurred ...

It really might be a case of don't do that.

-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
