Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8443EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 23:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EF4B23603
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 23:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbhAGX3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:29:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35508 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbhAGX3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 18:29:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107NQ54o074618;
        Thu, 7 Jan 2021 23:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=k78y12Jur+0+s1wSJPyPZW2Zon63/KMUveEXSz+5Img=;
 b=sXWanZA47s5Y5jzNACeZzR+S6hzxF0Tz9oWS8ylMu4HXbl7pouKCShhCAWtrPDQPYw3y
 mrje7+D14I5MbJNlQf/2C/j8CfR+Z3VKwkPcH8fgVA6FPdWOuVLTGZOvybhOUJEZN9G+
 3rEkROoEVoiMHBs6msv3UAnbO5pniH1tZgFlSZzGeSAEQqKxquvYmShX+naMrmmrJqAH
 RHESzmD3YFaJ5ArwimWaUR+pzEokQHcFLlPgxdBFtDwmpWfh8Gsexdunmouk4dSBwryT
 8RZbcOARvYouhL3m61QCzzxPlSFXNeozNAfoldvtTy/8xX9Klxl+t4GEetH22Mkd7K2Q OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepmevg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 23:28:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107NPRuA033051;
        Thu, 7 Jan 2021 23:28:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35w3g3f8rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 23:28:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107NSMmb010479;
        Thu, 7 Jan 2021 23:28:22 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 23:28:22 +0000
Date:   Thu, 7 Jan 2021 15:28:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20210107232821.GN6918@magnolia>
References: <20201209155211.GB1860561@bfoster>
 <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster>
 <20201212211439.GC632069@dread.disaster.area>
 <20201214155831.GB2244296@bfoster>
 <20201214205456.GD632069@dread.disaster.area>
 <20201215135003.GA2346012@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215135003.GA2346012@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070131
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 15, 2020 at 08:50:03AM -0500, Brian Foster wrote:
> On Tue, Dec 15, 2020 at 07:54:56AM +1100, Dave Chinner wrote:
> > On Mon, Dec 14, 2020 at 10:58:31AM -0500, Brian Foster wrote:
> > > On Sun, Dec 13, 2020 at 08:14:39AM +1100, Dave Chinner wrote:
> > > > On Fri, Dec 11, 2020 at 08:39:01AM -0500, Brian Foster wrote:
> > > > > On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
> > > > > > As for a mechanism for dynamically adding log incompat flags?
> > > > > > Perhaps we just do that in xfs_trans_alloc() - add an log incompat
> > > > > > flags field into the transaction reservation structure, and if
> > > > > > xfs_trans_alloc() sees an incompat field set and the superblock
> > > > > > doesn't have it set, the first thing it does is run a "set log
> > > > > > incompat flag" transaction before then doing it's normal work...
> > > > > > 
> > > > > > This should be rare enough it doesn't have any measurable
> > > > > > performance overhead, and it's flexible enough to support any log
> > > > > > incompat feature we might need to implement...
> > > > > > 
> > > > > 
> > > > > But I don't think that is sufficient. As Darrick pointed out up-thread,
> > > > > the updated superblock has to be written back before we're allowed to
> > > > > commit transactions with incompatible items. Otherwise, an older kernel
> > > > > can attempt log recovery with incompatible items present if the
> > > > > filesystem crashes before the superblock is written back.
> > > > 
> > > > Sure, that's what the hook in xfs_trans_alloc() would do. It can do
> > > > the work in the context that is going to need it, and set a wait
> > > > flag for all incoming transactions that need a log incompat flag to
> > > > wait for it do it's work.  Once it's done and the flag is set, it
> > > > can continue and wake all the waiters now that the log incompat flag
> > > > has been set. Anything that doesn't need a log incompat flag can
> > > > just keep going and doesn't ever get blocked....
> > > > 
> > > 
> > > It would have to be a sync transaction plus sync AIL force in
> > > transaction allocation context if we were to log the superblock change,
> > > which sounds a bit hairy...
> > 
> > Well, we already do sync AIL forces in transaction reservation when
> > we run out of log space, so there's no technical reason for this
> > being a problem at all. xfs_trans_alloc() is expected to block
> > waiting on AIL tail pushing....
> > 
> > > > I suspect this is one of the rare occasions where an unlogged
> > > > modification makes an awful lot of sense: we don't even log that we
> > > > are adding a log incompat flag, we just do an atomic synchronous
> > > > write straight to the superblock to set the incompat flag(s). The
> > > > entire modification can be done under the superblock buffer lock to
> > > > serialise multiple transactions all trying to set incompat bits, and
> > > > we don't set the in-memory superblock incompat bit until after it
> > > > has been set and written to disk. Hence multiple waits can check the
> > > > flag after they've got the sb buffer lock, and they'll see that it's
> > > > already been set and just continue...
> > > > 
> > > 
> > > Agreed. That is a notable simplification and I think much more
> > > preferable than the above for the dynamic approach.
> > > 
> > > That said, note that dynamic feature bits might introduce complexity in
> > > more subtle ways. For example, nothing that I can see currently
> > > serializes idle log covering with an active transaction (that may have
> > > just set an incompat bit via some hook yet not committed anything to the
> > > log subsystem), so it might not be as simple as just adding a hook
> > > somewhere.
> > 
> > Right, we had to make log covering away of the CIL to prevent it
> > from idling while there were multiple active committed transactions
> > in memory. So the state machine only progresses if both the CIL and
> > AIL are empty. If we had some way of knowing that a transaction is
> > in progress, we could check that in xfs_log_need_covered() and we'd
> > stop the state machine progress at that point. But we got rid of the
> > active transaction counter that we could use for that....
> > 
> > [Hmmm, didn't I recently have a patch that re-introduced that
> > counter to fix some other "we need to know if there's an active
> > transaction running" issue? Can't remember what that was now...]
> > 
> 
> I think you removed it, actually, via commit b41b46c20c0bd ("xfs: remove
> the m_active_trans counter"). We subsequently discussed reintroducing
> the same concept for the quotaoff rework [1], which might be what you're
> thinking of. That uses a percpu rwsem since we don't really need a
> counter, but I suspect could be reused for serialization in this use
> case as well (assuming I can get some reviews on it.. ;).
> 
> FWIW, I was considering putting those quotaoff patches ahead of the log
> covering work so we could reuse that code again in attr quiesce, but I
> think I'm pretty close to being able to remove that particular usage
> entirely.

I was thinking about using a rwsem to protect the log incompat flags --
code that thinks it might use a protected feature takes the lock in
read mode until commit; and the log covering code only clears the
flags if down_write_trylock succeeds.  That constrains the overhead to
threads that are trying to use the feature, instead of making all
threads pay the cost of bumping the counter.

> [1] https://lore.kernel.org/linux-xfs/20201001150310.141467-1-bfoster@redhat.com/
> 
> > > > This gets rid of the whole "what about a log containing an item that
> > > > sets the incompat bit" problem, and it provides a simple means of
> > > > serialising and co-ordinating setting of a log incompat flag....
> > > > 
> > > > > My question is how flexible do we really need to make incompatible log
> > > > > recovery support? Why not just commit the superblock once at mount time
> > > > > with however many bits the current kernel supports and clear them on
> > > > > unmount? (Or perhaps consider a lazy setting variant where we set all
> > > > > supported bits on the first modification..?)
> > > > 
> > > > We don't want to set the incompat bits if we don't need to. That
> > > > just guarantees user horror stories that start with "boot system
> > > > with new kernel, crash, go back to old kernel, can't mount root
> > > > filesystem anymore".
> > > > 
> > > 
> > > Indeed, that is a potential wart with just setting bits on mount. I do
> > > think this is likely to be the case with or without dynamic feature
> > > bits, because at least in certain cases we'll be setting incompat bits
> > > in short order anyways. E.g., one of the primary use cases here is for
> > > xattrs, which is likely to be active on any root filesystem via things
> > > like SELinux, etc. Point being, all it takes is one feature bit
> > > associated with some core operation to introduce this risky update
> > > scenario in practice.
> > 
> > That may well be the case for some distros and some root
> > filesystems, and that's an argument against using log incompat flags
> > for the -xattr feature-. It's not an argument against
> > dynamically setting and clearing log incompat features in general.
> > 
> 
> Sure. I mentioned in past mails that my concerns/feedback depend heavily
> on use case. xattrs is one of the two (?) or so motivating this work.
> 
> > That is, if xattrs are so wide spread that we expose users to
> > "upgrade-fail-can't downgrade" by use of a dynamic log incompat
> > flag, then we should not be making that feature dynamic and
> > "autoset". In this situation, it needs to be opt-in and planned,
> > likely done in maintenance downtime rather than a side effect of a
> > kernel upgrade.
> > 
> > So, yeah, this discussion is making me think that the xattr logging
> > upgrade is going to need a full ATTR3 feature bit like the other
> > ATTR and ATTR2 feature bits, not just a log incompat bit...
> > 
> 
> Perhaps. Not using this at all for xattrs does address quite a bit of my
> concerns, but I think if we wanted the potential flexibility of the log
> incompat bit down the road, it might be reasonable to manage the
> experimental cycle "manually" as described above (i.e., essentially
> don't set/clear that bit automatically for a period of time). I don't
> feel strongly about one approach over the other in that regard, though,
> just that we don't immediately turn the mechanism on right out of the
> gate because the feature bit mechanism happens to support it.

I suggested to Allison that enabling logged xattrs should be (for now) a
CONFIG_XFS_DEBUG=y mount option so that only bleeding edge people
actually get the new functionality.  As we build confidence in the
feature we can think about letting the kernel turn it on automatically.

As for a persistent feature flag, let's use directory parent pointers
since that will force us to create a new rocompat flag anyway.

> > > I dunno... I'm just trying to explore whether we can simplify this whole
> > > concept to something more easily managed and less likely to cause us
> > > headache. I'm a bit concerned that we're disregarding other tradeoffs
> > > like the complexity noted above, the risk and cost of bugs in the
> > > mechanism itself (because log recovery has historically been so well
> > > tested.. :P) or whether the idea of new kernels immediately delivering
> > > new incompat log formats is a robust/reliable solution in the first
> > > place. IIRC, the last time we did this was ICREATE and that was hidden
> > > behind the v5 update. IOW, for certain things like the xattr rework, I'd
> > > think that kind of experimental stabilization cycle is warranted before
> > > we'd consider enabling such a feature, even dynamically (which means a
> > > revertible kernel should be available in common/incremental upgrade
> > > cases).
> > 
> > IMO, the xattr logging rework is most definitely under the
> > EXPERIMENTAL umbrella and that was always going to be the case.
> > Also, I don't think we're ignoring the potential complexity of
> > dynamically setting/clearing stuff - otherwise we wouldn't be having
> > this conversation about how simple we can actually make it. If it
> > turns out that we can't do it simply, then setting/clearing at
> > mount/unmount should be considered "plan B"....
> > 
> 
> I'm more approaching this from a "what are the requirements and how/why
> do they justify the associated complexity?" angle. That's why I'm asking
> things like how much difference does a dynamic bit really make for
> something like xattrs. But I agree that's less of a concern when
> associated with more obscure or rarely used operations, so on balance I
> think that's a fair approach to this mechanism provided we consider
> suitability on a per feature basis.

Hm.  If I had to peer into my crystal ball I'd guess that the current
xattr logging scheme works fine for most xattr users, so I wouldn't
worry much about the dynamic bit.

However, I could see things like atomic range exchange being more
popular, in which case people might notice the overhead of tracking when
we can turn off the feature bit...

--D

> > But right now, I think the discussion has come up with some ideas to
> > greatly simplify the dynamic flag setting + clearing....
> > 
> 
> Agreed, thanks.
> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
