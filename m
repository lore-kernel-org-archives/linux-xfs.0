Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8E5C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2CF20575
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RfXU7wW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgD1Web (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:34:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1Wea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:34:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMXElr116291;
        Tue, 28 Apr 2020 22:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=l57cZQ5c+rZGUAK3TDT5WqM70cMAorPyp5JsiaHe0C4=;
 b=RfXU7wW+iVghxkBdkyQ9A7XgFASQyx7p7ns2oKRkVD9atYaGdLoqYrVilZ4glyjoSoYQ
 1dtHS6TJlkEhys+UusuAYj7hIFjKjtNQqL0vMqXThA43lLbjWerbDPx68ZNfpOjRj+8+
 Ns+sA/9msIsT9ATaAfGbCc4IbupVL4yxOospWlfE3zEYGs/3ViDZ/g7wGwx3Nn92W7Xm
 Tl0wReGsfdVxzXpzdXNQ/MnmaBin3SLNDL14z54+CkuPImsYRRx9xA5WyI20S/5RgrUP
 4S/XkDr1R3ueK6iY3sQ5hQf2l5vMeoY1Oo6IpUwapSqLeObtQfytLr2VUJArgM7faDB/ hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01ns80t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:34:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMVrnT143611;
        Tue, 28 Apr 2020 22:34:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30pvcych1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:34:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMYOrA027267;
        Tue, 28 Apr 2020 22:34:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:34:23 -0700
Date:   Tue, 28 Apr 2020 15:34:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200428223422.GL6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <20200422161854.GB37352@bfoster>
 <20200428061208.GA18850@infradead.org>
 <20200428124342.GA10106@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428124342.GA10106@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 08:43:42AM -0400, Brian Foster wrote:
> On Mon, Apr 27, 2020 at 11:12:08PM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 22, 2020 at 12:18:54PM -0400, Brian Foster wrote:
> > > - Transaction reorder
> > > 
> > > Virtualizing the transaction reorder across all several files/types
> > > strikes me as overkill for several reasons. From a code standpoint,
> > > we've created a new type enumeration and a couple fields (enum type and
> > > a function) in a generic structure to essentially abstract out the
> > > buffer handling into a function. The latter checks another couple of blf
> > > flags, which appears to be the only real "type specific" logic in the
> > > whole sequence. From a complexity standpoint, the reorder operation is a
> > > fairly low level and internal recovery operation. We have this huge
> > > comment just to explain exactly what's happening and why certain items
> > > have to be ordered as such, or some treated like others, etc. TBH it's
> > > not terribly clear even with that documentation, so I don't know that
> > > splitting the associated mapping logic off into separate files is
> > > helpful.
> > 
> > I actually very much like idea of moving any knowledge of the individual
> > item types out of xfs_log_recovery.c.  In reply to the patch I've
> > suggsted an idea how to kill the knowledge for all but the buffer and
> > icreate items, which should make this a little more sensible.
> > 
> 
> I mentioned to Darrick the other day briefly on IRC that I don't
> fundamentally object to splitting up xfs_log_recover.c. I just think
> this mechanical split out of the existing code includes too much of the
> implementation details of recovery and perhaps abstracts a bit too much.
> I find the general idea much more acceptable with preliminary cleanups
> and a more simple interface.

It's cleaned up considerably with hch's cleanup patches 1-5 of 2. ;)

> > I actually think we should go further in one aspect - instead of having
> > the item type to ops mapping in a single function in xfs_log_recovery.c
> > we should have a table that the items can just add themselves to.
> > 
> 
> That sounds reasonable, but that's more about abstraction mechanism than
> defining the interface. I was more focused on simplifying the latter in
> my previous comments.

<nod>

> > > - Readahead
> > > 
> > > We end up with readahead callouts for only the types that translate to
> > > buffers (so buffers, inode, dquots), and then those callouts do some
> > > type specific mapping (that is duplicated within the specific type
> > > handers) and issue a readahead (which is duplicated across each ra_pass2
> > > call). I wonder if this would be better abstracted by a ->bmap() like
> > > call that simply maps the item to a [block,length] and returns a
> > > non-zero length if the core recovery code should invoke readahead (after
> > > checking for cancellation). It looks like the underlying implementation
> > > of those bmap calls could be further factored into helpers that
> > > translate from the raw record data into the type specific format
> > > structures, and that could reduce duplication between the readahead
> > > calls and the pass2 calls in a couple cases. (The more I think about,
> > > the more I think we should introduce those kind of cleanups before
> > > getting into the need for function pointers.)
> > 
> > That sounds more complicated what we have right now, and even more so
> > with my little xlog_buf_readahead helper.  Yes, the methods will all
> > just call xlog_buf_readahead, but they are trivial two-liners that are
> > easy to understand.  Much easier than a complicated calling convention
> > to pass the blkno, len and buf ops back.
> > 
> 
> Ok. The above was just an idea to simplify things vs. duplicating
> readahead code and recovery logic N times. I haven't seen your
> idea/code, but if that problem is addressed with a helper vs. a
> different interface then that seems just as reasonable to me.
> 
> > > - Recovery (pass1/pass2)
> > > 
> > > The core recovery bits seem more reasonable to factor out in general.
> > > That said, we only have two pass1 callbacks (buffers and quotaoff). The
> > > buffer callback does cancellation management and the quotaoff sets some
> > > flags, so I wonder why those couldn't just remain as direct function
> > > calls (even if we move the functions out of xfs_log_recover.c). There
> > > are more callbacks for pass2 so the function pointers make a bit more
> > > sense there, but at the same time it looks like the various intents are
> > > further abstracted behind a single "intent type" pass2 call (which has a
> > > hardcoded XLOG_REORDER_INODE_LIST reorder value and is about as clear as
> > > mud in that context, getting to my earlier point).
> > 
> > Again I actually like the callouts, mostly because they make it pretty
> > clear what is going on.  I also really like the fact that the recovery
> > code is close to the code actually writing the log items.

Looking back at that, I realize that (provided nobody minds having
function dispatch structures that are sort of sparse) there's no reason
why we need to have separate xlog_recover_intent_type and
xlog_recover_item_type structures.

> I find both the runtime logging and recovery code to be complex enough
> individually that I prefer not to stuff them together, but there is
> already precedent with dfops and such so that's not the biggest deal to
> me if the interface is simplified (and hopefully amount of code
> reduced).

I combined them largely on the observation that with the exception of
buffers, log item recovery code is generally short and not worth
creating even more files.  224 is enough.

--D

> Brian
> 
