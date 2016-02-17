Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88C987CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 04:04:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D4198F8039
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:04:26 -0800 (PST)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	R4tKa7Zh4ZoFHKQy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:04:23 -0800 (PST)
Received: by mail-io0-f170.google.com with SMTP id z135so31740330iof.0
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:04:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160217095646.GA21482@infradead.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
	<20160215204614.7977.2848.stgit@birch.djwong.org>
	<20160217095646.GA21482@infradead.org>
Date: Wed, 17 Feb 2016 10:04:23 +0000
Message-ID: <CAL3q7H5NRUXvo=mEtGr4-S4yPT7k_yw6LsMAq_V8bPD1T=7r0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] generic/304: fix high offset
From: Filipe Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, fstests@vger.kernel.org, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Feb 17, 2016 at 9:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Feb 15, 2016 at 12:46:14PM -0800, Darrick J. Wong wrote:
>> "Invalid argument" is a better response to an impossibly high offset
>> dedupe request than "extents don't match", so change the test.
>
> What does btrfs return here?

-EINVAL, so this makes the test pass on btrfs.

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
