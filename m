Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9EP5NM233113
	for <linux-xfs@oss.sgi.com>; Wed, 9 Nov 2011 08:25:06 -0600
Received: from exprod7og123.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A863E56AFDF
	for <linux-xfs@oss.sgi.com>; Wed,  9 Nov 2011 06:25:04 -0800 (PST)
Received: from exprod7og123.obsmtp.com (exprod7og123.obsmtp.com [64.18.2.24])
	by cuda.sgi.com with SMTP id Xoy0DfvnaTuGYdxr for
	<linux-xfs@oss.sgi.com>; Wed, 09 Nov 2011 06:25:04 -0800 (PST)
Received: from mail-yw0-f43.google.com ([209.85.213.43]) (using TLSv1) by
	exprod7ob123.postini.com ([64.18.6.12]) with SMTP
	ID DSNKTrqNPx81kNQQJGzxFSfuZU4Ch9+x+99t@postini.com;
	Wed, 09 Nov 2011 06:25:04 PST
Received: by ywp17 with SMTP id 17so2544142ywp.16
	for <linux-xfs@oss.sgi.com>; Wed, 09 Nov 2011 06:25:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111109080133.GB20604@infradead.org>
References: <loom.20111108T180925-222@post.gmane.org>
	<20111109080133.GB20604@infradead.org>
Date: Wed, 9 Nov 2011 08:25:02 -0600
Message-ID: <CAGedfzmcmfLXhBEzm9yhpRQTf-7dnMenXqe0FABAzJgP0rxSUA@mail.gmail.com>
Subject: Re: XFS realtime O_DIRECT failures
From: Alan Cook <acook@visionpointsystems.com>
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
Cc: linux-xfs@oss.sgi.com

On Wed, Nov 9, 2011 at 2:01 AM, Christoph Hellwig <hch@infradead.org> wrote:
> It might sounda a bit harsh, but the problem is that use the realtime
> subvolume.  It hasn't really been maintained or been part of the tested
> setup, and most distros in the know ship with it disabled.  I went
> through and fixed it when we got bug reports once in a while, and I'm
> happy to look into your issues once I get a bit spare time, but in
> general use is highly discouraged.   Is there any specific reason why
> you want to use the RT subvolume?

I am streaming high-resolution images to be compressed through
hardware and need to separate the data from the meta data for
compression purposes.=A0 XFS gave that for free if I used a realtime
subvolume.

I originally started on kernel 2.6.27 (CentOS 5.5) which had no issues
with the RT subvolume and direct writes.=A0 I was then moved to kernel
2.6.32 (SUSE 11) which does have the issue.

I appreciate your willingness to help.=A0 Are there any alternatives or
suggestions for splitting the data and meta data?=A0 Any direction you
can give on where to start looking or what I could do to track down
the exact cause of the bug?

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
