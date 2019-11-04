Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55417CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 21:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B3320659
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 21:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HO31hhHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfKDVMa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 16:12:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57568 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfKDVMa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 16:12:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KxLLg146817;
        Mon, 4 Nov 2019 21:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UdhC0i7d9IaFSMuv6szahCqY8IPwx+vmyPo5h5DVd0o=;
 b=HO31hhHlxesDFYg5LVIBonN40zWIKCjbbWwNfwNqFlwRHkVvIGZvpyFr64Z6Z8ULghK8
 d0doryXd0fGGFlJssn3fDeUyOwh8XLV269ZpV+HIIso1Gwjw0iAWb/PrJD90fCjqemy0
 /zOhsHm/f28ckBaavxEbD7GGDWmmO4d71D8dH81qx2qz/BoJko5IcgRHWfwvY7fpgX6p
 3QfGjxb2rD3mAJEiP/A/qa9fvuYJjiU0EmK9dFuJc3hZpVglQuaCNSNnZKWKtzcwpZ/9
 BPXya/9hLZCyn7Py88LzqFy5zsW6w26gq4YW5bpuDJSWcztt0PL4s9SpsArGExMecI6k gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rpt4rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 21:12:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4L2cXl026692;
        Mon, 4 Nov 2019 21:12:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w1kacd1ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 21:12:09 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4LC7Ge027382;
        Mon, 4 Nov 2019 21:12:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 13:12:06 -0800
Date:   Mon, 4 Nov 2019 13:12:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 12/16] xfs: dont set sb in xfs_mount_alloc()
Message-ID: <20191104211205.GL4153244@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259466607.28278.4456308072088112584.stgit@fedora-28>
 <20191101201536.GG15222@magnolia>
 <ae8c1a5f4c357c6c9060f09b374bad472b422ebf.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8c1a5f4c357c6c9060f09b374bad472b422ebf.camel@themaw.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 02, 2019 at 12:41:39PM +0800, Ian Kent wrote:
> On Fri, 2019-11-01 at 13:15 -0700, Darrick J. Wong wrote:
> > On Fri, Nov 01, 2019 at 03:51:06PM +0800, Ian Kent wrote:
> > > When changing to use the new mount api the super block won't be
> > > available when the xfs_mount struct is allocated so move setting
> > > the
> > > super block in xfs_mount to xfs_fs_fill_super().
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_super.c |    7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 4b570ba3456a..62dfc678c415 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -1560,8 +1560,7 @@ xfs_destroy_percpu_counters(
> > >  }
> > >  
> > >  static struct xfs_mount *
> > > -xfs_mount_alloc(
> > > -	struct super_block	*sb)
> > > +xfs_mount_alloc(void)
> > >  {
> > >  	struct xfs_mount	*mp;
> > >  
> > > @@ -1569,7 +1568,6 @@ xfs_mount_alloc(
> > >  	if (!mp)
> > >  		return NULL;
> > >  
> > > -	mp->m_super = sb;
> > 
> > Just out of curiosity, is there any place where we need m_super in
> > between here...
> > 
> > >  	spin_lock_init(&mp->m_sb_lock);
> > >  	spin_lock_init(&mp->m_agirotor_lock);
> > >  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> > > @@ -1605,9 +1603,10 @@ xfs_fs_fill_super(
> > >  	 * allocate mp and do all low-level struct initializations
> > > before we
> > >  	 * attach it to the super
> > >  	 */
> > > -	mp = xfs_mount_alloc(sb);
> > > +	mp = xfs_mount_alloc();
> > >  	if (!mp)
> > >  		goto out;
> > > +	mp->m_super = sb;
> > 
> > ...and here?  For example, logging errors?  AFAICT the only thing
> > that
> > goes on between these two points is option parsing, right?  (And the
> > parsing has its own prefixed logging, etc.)
> 
> Yes, only option parsing is going on between these two points.
> 
> And, for now, the error reporting is caught by the VFS.
> 
> There is one location in xfs_fc_parse_param() where an xfs log
> message could be emitted although it's never reached (because of
> the return if the fs_parse() call fails).
> 
> If log messages were issued in between these two points the consequence
> is a missing block device name in the message. You remember, a check on
> mp->m_super was added to __xfs_printk() to cover this case when struct
> xfs_mount field m_fsname was eliminated.

It's true that (AFAICT) this is the only place where xfs might need
mp->m_super but it doesn't yet have one, but you'd agree that this is a
significant change to the scoping rules, right?  In the past there was
never a place in xfs where we'd have to check mp->m_super == NULL, but
now we have to keep that possibility in mind, at least for any function
that can be called before get_tree_bdev.

> This potential lack of device name in log messages is a problem I can't
> fix because the block device isn't obtained until after parameter
> parsing, just before the super block is acquired. Changing that in the
> VFS would be quite significant so I'm stuck!

Um, we used to obtain the block device and the superblock before we
started option parsing.  I guess the worst that happens is that anything
trying to dereference mp->m_super is just going to crash...

...oh well I should probably go complain to the new series, not this
one.

--D


> > 
> > --D
> > 
> > >  	sb->s_fs_info = mp;
> > >  
> > >  	error = xfs_parseargs(mp, (char *)data);
> > > 
> 
