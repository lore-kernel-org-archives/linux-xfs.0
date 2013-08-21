Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E49687FFD
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 08:02:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C0BB28F8035
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 06:02:03 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1AFXIPz513USFuv5 for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 06:02:02 -0700 (PDT)
Date: Wed, 21 Aug 2013 15:01:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130821130152.GA9709@quack.suse.cz>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<20130821064357.GA8822@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130821064357.GA8822@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

On Tue 20-08-13 23:43:57, Christoph Hellwig wrote:
> Sorry for being late to the game, but I don not like the in-kernel
> interface here at all.  Given that Q_XGETQSTATV is a strict superset
> of Q_XGETQSTAT there is no need for the second method - just always
> fill out the larger in-kernel structure and only copy the smaller
> information to userspace for the Q_XGETSTAT case.  That keeps the amount
> of code required in the implementations of the methods low and follows
> the model used elsewhere in the kernel (e.g. stat and statfs)
  Well, the trouble is with gquota vs pquota - previously we report in
qs_gquota field either group quotas or project quotas depending on what is
turned on. Generic quota code doesn't know this so xfs get_xstatev() would
have to recognize whether it is being called from the old Q_XGETSTAT
quotactl or from the new Q_XGETSTATV quotactl to know where to fill in
project quotas. And at that point you somewhat loose the elegancy of using
one interface - we could set qs_version to some special value so that
.get_xstatev() recognizes this and does the magic but that doesn't seem very
different from the extra call...

Some duplication could be certainly avoided within XFS itself.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
