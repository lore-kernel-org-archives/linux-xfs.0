Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6442F7F60
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 04:00:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EED10AC003
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 02:00:51 -0700 (PDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id 1ZzUTmeJmOSegbuc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2015 02:00:50 -0700 (PDT)
Received: by padjw17 with SMTP id jw17so25536207pad.2
	for <xfs@oss.sgi.com>; Thu, 04 Jun 2015 02:00:49 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: Rules for calling ->releasepage()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20150604083953.GB5923@quack.suse.cz>
Date: Thu, 4 Jun 2015 03:00:44 -0600
Message-Id: <75C1F36D-E42F-4897-A1CB-232EA0938F83@dilger.ca>
References: <20150604083953.GB5923@quack.suse.cz>
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
Cc: mfasheh@suse.de, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Jun 4, 2015, at 2:39 AM, Jan Kara <jack@suse.cz> wrote:
> 
>  Hello,
> 
> we were recently debugging an issue where customer was hitting
> warnings in xfs_vm_releasepage() which was complaining that the
> page it was called for has delay-allocated buffers. After some
> debugging we realized that indeed try_to_release_page() call from
> shrink_active_list() can happen for a page in arbitrary state (that
> call happens only if buffer_heads_over_limit is set so that is
> the reason why we normally don't see that).
> 
> Hence comes my question: What are the rules for when releasepage()
> can be called? And what is the expected outcome? We are certainly
> guaranteed to hold page lock. try_to_release_page() also makes
> sure the page isn't under writeback.  But what is ->releasepage()
> supposed to do with a dirty page?
> Generally IFAIU we aren't supposed to discard dirty data but I
> wouldn't bet on all filesystems getting it right because the
> common call paths make sure page is clean. I would almost say we
> should enforce !PageDirty in try_to_release_page() if it was not
> for that ext3 nastyness of cleaning buffers under a dirty page -
> hum, but maybe the right answer for that is ripping ext3 out of
> tree (which would also allow us to get rid of some code in the
> blocklayer for bouncing journaled data buffers when stable writes
> are required).
> 
> Thoughts?

I've been an advocate of removing ext3 from the tree for a few years
already.  It doesn't do anything better than ext4, but it does a lot
of things worse.  Distros have been using CONFIG_EXT4_USE_FOR_EXT23
for several years now without problems AFAIK so this is safe even
if users don't want to upgrade their on-disk features in case they
want to be able to downgrade to an older kernel.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
