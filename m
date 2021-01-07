Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CA9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B112D235DD
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbhAGVb1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 16:31:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57854 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhAGVb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 16:31:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107LTXIG194897;
        Thu, 7 Jan 2021 21:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rjv4oHE0rtsaJjCEdImwilTWU6TQ3k9QYoqTOpN+bic=;
 b=TW8iV90XyYwfSJcxZKV5fUsHdEa0tBGzI+XLyGHjeMTQR7mYZNAnq0bcCQiccdDW2I0g
 BK00/mNd45wUK20gGq+UPfrsd0bkiZvHqnPt/ttCmPdvcKQGfuaLN4T6uJgJn8HEMiwu
 B7PQETe1GKHBZ9BBM5ajA0u6yCuPvuWlfSFI+TxOvW+Iqc3HD2TXTdPwJmMEfbYH0By+
 vFohxmbh+Ztj15G2uySOYHV7i6EQILmSPHSZqTiSPuzLt93i9QrWEFPoyJ5JCFp2uOoD
 rI6u/LsKwD24jUzgShOGL7Q5tUD2VCvEyFoJoIuiHO674rs0x9EQfJsDS43Hq2gY/9Pk zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35wftxe134-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 21:30:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107LBRRB102226;
        Thu, 7 Jan 2021 21:28:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35w3g3awag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 21:28:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107LSg4x021227;
        Thu, 7 Jan 2021 21:28:42 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 13:28:42 -0800
Date:   Thu, 7 Jan 2021 13:28:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: lift writable fs check up into log worker task
Message-ID: <20210107212841.GM6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-3-bfoster@redhat.com>
 <20210107183422.GN38809@magnolia>
 <20210107195321.GA845369@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107195321.GA845369@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 02:53:21PM -0500, Brian Foster wrote:
> On Thu, Jan 07, 2021 at 10:34:22AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 06, 2021 at 12:41:20PM -0500, Brian Foster wrote:
> > > The log covering helper checks whether the filesystem is writable to
> > > determine whether to cover the log. The helper is currently only
> > > called from the background log worker. In preparation to reuse the
> > > helper from freezing contexts, lift the check into xfs_log_worker().
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 12 +++++-------
> > >  1 file changed, 5 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index b445e63cbc3c..4137ed007111 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -1050,13 +1050,11 @@ xfs_log_space_wake(
> > >   * can't start trying to idle the log until both the CIL and AIL are empty.
> > >   */
> > >  static int
> > 
> > I think this is a predicate, right?  Should this function return a bool
> > instead of an int?
> > 
> 
> Yes, we could change that to return a bool.
> 
> > This function always confuses me slightly since it pushes us through the
> > covering state machine, and (I think) assumes that someone will force
> > the CIL and push the AIL if it returns zero. :)
> > 
> 
> It basically assumes that the caller will issue a covering commit
> (xfs_sync_sb()) if indicated, and so progresses ->l_covered_state along
> in anticipation of that (i.e. NEED -> DONE). The log subsystem side
> detects that covering commit and makes further state changes (such as
> DONE -> NEED2) for the next time around in the background worker.
> 
> > To check my thinking further-- back in that thread I started about
> > setting and clearing log incompat flags, I think Dave was pushing me to
> > clear the log incompat flags just before we call xfs_sync_sb when the
> > log is in NEED2 state, right?
> > 
> 
> In general, I think so. I don't think it technically has to be NEED2 (as
> opposed to NEED || NEED2), but in general the idea is to make any such
> final superblock updates in-core just before the quiesce completes and
> allow the log covering sequence to commit it for us. This is similar to
> how this series handles the lazy superblock counters (with the caveat
> that that stuff just happened to already be implemented inside
> xfs_sync_sb()).
> 
> FWIW, we could also enforce that such final superblock updates reset
> covered state of the log to NEED2 if we wanted to. I went back and forth
> on that a bit but decided to leave out unnecessary complexity for the
> first pass.
> 
> > AFAICT the net effect of this series is to reorder the log code so that
> > xfs_log_quiesce covers the log (force cil, push ail, log two
> > transactions containing only the superblock), and adds an xfs_log_clean
> > that quiesces the log and then writes an unmount record after that.
> > 
> 
> Yep.
> 
> > Two callers whose behavior does not change with this series are: 1) The
> > log worker quiesces the log when it's idle; and 2) unmount quiesces the
> > log and then writes an unmount record so that the next mount knows it
> > can skip replay entirely.
> > 
> 
> Right, though just to be clear, quiesce never covered the log before
> this series. It effectively drained the log by forcing the log and
> pushing the AIL until empty, but then just wrote the unmount record to
> mark it clean...

<nod> Right, I should've echoed that old quiesce only did force cil and
push ail, so freeze and unmount do more now.

> > The big difference is 3) freeze now only covers the log, whereas before
> > it would cover, write an unmount record, and immediately redirty the log
> > to force replay of the snapshot, right?
> > 
> 
> Yes. As above, unmount now also does a log cover -> unmount record
> instead of just writing the unmount record. This is harmless because we
> end up in the clean state either way, but I've tried to point this out
> in the commit logs and whatnot so it's apparent to reviewers. We could
> technically make the log cover during quiesce optional with a new
> parameter or something, but it just didn't seem worth it once we start
> overloading the covering sequence to handle things like lazy sb
> accounting (or log incompat bits, etc.).
>
> > Assuming I understood all that, my next question is: Eric Sandeen was
> > working on a patchset to process unlinked inodes unconditionally on
> > mount so that frozen fs images can be written out with the unmount
> > record (because I guess people make ro snapshots of live fs images and
> > then balk when they have to make the snapshot rw to run log recovery.
> > Any thoughts about /that/? :)
> > 
> 
> Eric had mentioned that to me as well. I don't quite recall what the
> impediment to making that change was the last time around (Eric?), but
> my view was that is orthogonal to this series. IOW, the primary
> motivations for this series are to clean up the whole xfs_quiesce_attr()
> -> xfs_log_quiesce() mess and facilitate the reuse of covering for
> things like lazy sb accounting and log incompat bit management. We can
> decide whether to quiesce or clean the log on freeze independently and
> that's really only a single line tweak to the last patch of the series
> (i.e., continue to clean the log and just don't redirty it).

Oh, it's totally orthogonal, but touched some of the same code parts. :)

IIRC I applied it then hit fstests regressions and kicked it out again.

--D

> Brian
> 
> > --D
> > 
> > > -xfs_log_need_covered(xfs_mount_t *mp)
> > > +xfs_log_need_covered(
> > > +	struct xfs_mount	*mp)
> > >  {
> > > -	struct xlog	*log = mp->m_log;
> > > -	int		needed = 0;
> > > -
> > > -	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
> > > -		return 0;
> > > +	struct xlog		*log = mp->m_log;
> > > +	int			needed = 0;
> > >  
> > >  	if (!xlog_cil_empty(log))
> > >  		return 0;
> > > @@ -1271,7 +1269,7 @@ xfs_log_worker(
> > >  	struct xfs_mount	*mp = log->l_mp;
> > >  
> > >  	/* dgc: errors ignored - not fatal and nowhere to report them */
> > > -	if (xfs_log_need_covered(mp)) {
> > > +	if (xfs_fs_writable(mp, SB_FREEZE_WRITE) && xfs_log_need_covered(mp)) {
> > >  		/*
> > >  		 * Dump a transaction into the log that contains no real change.
> > >  		 * This is needed to stamp the current tail LSN into the log
> > > -- 
> > > 2.26.2
> > > 
> > 
> 
