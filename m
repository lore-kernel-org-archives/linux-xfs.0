Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A55B7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 14:32:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6026D8F8040
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 12:32:46 -0700 (PDT)
Received: from mail-qk0-f181.google.com (mail-qk0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	f8o7xGSKuqCVGw06 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 12:32:45 -0700 (PDT)
Received: by qkch123 with SMTP id h123so78116855qkc.0
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 12:32:44 -0700 (PDT)
Date: Mon, 24 Aug 2015 15:32:42 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824193242.GE28944@mtj.duckdns.org>
References: <20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
	<20150824145150.GA10029@mtj.duckdns.org>
	<20150824171144.GB27262@mtj.duckdns.org>
	<20150824190847.GA4234@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824190847.GA4234@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello, Jan.

On Mon, Aug 24, 2015 at 09:08:47PM +0200, Jan Kara wrote:
> Inode may contain writeback pages (but not dirty pages) without being on
> any of the dirty lists. That is correct. Josef Bacik had patches to create

Hmmm... Can you please expand on how / why that happens?  It's kinda
weird to require writeback to walk all inodes regardless of their
dirty states.

> a list to track inodes with pages under writeback but they clashed with
> your patch series and they didn't get rebased yet AFAIR.

Wouldn't it make more sense to simply put them on one of the existing
b_* lists?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
