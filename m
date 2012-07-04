Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6449dh9161019 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 23:09:39 -0500
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 64U33lKA54bDL0IW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jul 2012 21:09:37 -0700 (PDT)
Received: by wgbed3 with SMTP id ed3so4908105wgb.32
	for <xfs@oss.sgi.com>; Tue, 03 Jul 2012 21:09:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120703231122.GB19223@dastard>
References: <4FF2F41F.5000504@gmail.com> <20120703160949.GD855@infradead.org>
	<20120703231122.GB19223@dastard>
From: Igor M Podlesny <for.poige+xfs@gmail.com>
Date: Wed, 4 Jul 2012 12:09:06 +0800
Message-ID: <CA+sTkh4jk5wAoD32jfe2stzhKpSyB_GCXHSZSp9zjPc+ZfR5Hw@mail.gmail.com>
Subject: Re: Backporting the concurrent direct IO write fix to 3.4
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kerin Millar <kerframil@gmail.com>, xfs@oss.sgi.com

On 4 July 2012 07:11, Dave Chinner <david@fromorbit.com> wrote:
[...]
>> On the one hand I'd love to see these patches go into 3.4-stable as it's
>> going to be a long term release,
>
> Is it? So we will have long term support kernels for 3.0.x, 3.2.x
> and now 3.4.x? 3.0.x is the long term stable kernel I'm targetting
> for backports and there's no way I can really handle more than
> that...

   That's quite a pity! In production there's often even 2.6.32 since
it's chosen as RHEL6's kernel.

--

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
