Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6E7C4BA3B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 032CC2469D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgB0Nfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 08:35:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729076AbgB0Nfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:35:52 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RDYveT012648
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 08:35:51 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ydcnhm732-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 08:35:50 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 27 Feb 2020 13:35:49 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 13:35:46 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RDZj1658720436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 13:35:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2DAFAE045;
        Thu, 27 Feb 2020 13:35:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F345AE051;
        Thu, 27 Feb 2020 13:35:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.82])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 13:35:44 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 3/7] xfs: xfs_attr_calc_size: Calculate Bmbt blks only once
Date:   Thu, 27 Feb 2020 19:08:38 +0530
Organization: IBM
In-Reply-To: <20200227115340.GA5604@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <4371238.mKpYxNBjvR@localhost.localdomain> <20200227115340.GA5604@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022713-0012-0000-0000-0000038AD18F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022713-0013-0000-0000-000021C77ADE
Message-Id: <3274452.i3yBbPSjS3@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_04:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, February 27, 2020 5:23 PM Brian Foster wrote: 
> On Thu, Feb 27, 2020 at 02:29:16PM +0530, Chandan Rajendra wrote:
> > On Wednesday, February 26, 2020 10:12 PM Brian Foster wrote: 
> > > On Wed, Feb 26, 2020 at 08:33:12PM +0530, Chandan Rajendra wrote:
> > > > On Tuesday, February 25, 2020 9:41 PM Brian Foster wrote: 
> > > > > On Mon, Feb 24, 2020 at 09:30:40AM +0530, Chandan Rajendra wrote:
> > > > > > The number of Bmbt blocks that is required can be calculated only once by
> > > > > > passing the sum of total number of dabtree blocks and remote blocks to
> > > > > > XFS_NEXTENTADD_SPACE_RES() macro.
> > > > > > 
> > > > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > > > ---
> > > > > 
> > > > > According to the cover letter this is fixing a reservation calculation
> > > > > issue, though the commit log kind of gives the impression it's a
> > > > > refactor. Can you elaborate on what this fixes in the commit log?
> > > > > 
> > > > 
> > > > XFS_NEXTENTADD_SPACE_RES() first figures out the number of Bmbt leaf blocks
> > > > needed for mapping the 'block count' passed to it as the second argument.
> > > > When calculating the number of leaf blocks, it accommodates the 'block count'
> > > > argument in groups of XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp). For each such
> > > > group it decides that a bmbt leaf block is required. For each of the leaf
> > > > blocks that needs to be allocated, it assumes that there will be a split of
> > > > the bmbt tree from root to leaf. Hence it multiplies the number of leaf blocks
> > > > with the maximum height of the tree.
> > > > 
> > > > With two individual calls to XFS_NEXTENTADD_SPACE_RES() (one is indirectly
> > > > through the call to XFS_DAENTER_BMAPS() => XFS_DAENTER_BMAP1B() and the other
> > > > is for remote attr blocks) we miss out on the opportunity to group the bmbt
> > > > leaf blocks and hence overcompensate on the bmbt blocks calculation.
> > > > 
> > > > Please let me know if my understanding is incorrect.
> > > > 
> > > 
> > > Ok, thanks. I think I follow the intent. This patch is actually intended
> > > to reduce block reservation by simplifying this calculation, right?
> > 
> > I noticed xfs/132 test failing when I had changed the code to have 32-bit
> > xattr extent counter. The corresponding mount failure was due to log size
> > checks failing in xfs_log_mount(). The difference in value returned by
> > xfs_log_calc_minimum_size() => xfs_log_get_max_trans_res() =>
> > xfs_log_calc_max_attrsetm_res() was pretty large.
> > 
> > Upon code inspection I found the inconsistencies in
> > xfs_log_calc_max_attrsetm_res() which are described in the cover letter and as
> > part of the commit message of the last patch.
> > 
> 
> Ok, so the fixes to xfs_log_calc_max_attrsetm_res() are what actually
> fixed the test failure? If so, that strikes me as a good independent fix
> candidate (re: refactoring) because the commit log for that one should
> probably describe the observable problem and the fix separate from other
> issues.
> 
> > After a quick chat with Dave on irc, we figured that the best approach was to
> > convert xfs_attr_calc_size() into a helper function so that the size
> > calculations for an xattr set operation is placed in a single function. These
> > values can then be used by other functions like xfs_attr_set() and
> > xfs_log_calc_max_attrsetm_res().
> > 
> > Along the way, I found that the mount time reservation was incorrectly done as
> > well. For E.g. dabtree splits getting accounted as part of mount time
> > reservation was wrong. Due to these reasons and others listed in the cover
> > letter I ended up changing the mount time and run time reservation
> > calculations.
> > 
> > Hence, The reduced reservation sizes are actually a side effect of fixing the
> > inconsistencies.
> > 
> 
> Ok, so most of the rest sounds like bogosity discovered by code
> inspection. That's not that surprising given that transaction
> reservations are worst case values and thus it seems we sometimes get
> away with bogus calculations just so long as the reservations are large
> enough. :)
> 
> As it is, the final result of this patchset looks nice to me, it's just
> a matter of getting there more incrementally to facilitate reviewing the
> changes being made. FWIW, if we do end up with a final "fix the broken
> xattr res calculation" patch at the end of the series, I think it would
> be helpful to have a very deliberate commit log that contains something
> like the following:
> 
> 'The xattr reservation currently consists of:
> 
> 	- superblock
> 	- dabtree * maxdepth
> 	- ...
> 
> This calculation is bogus because it double accounts X as part of Y and
> Z, doesn't account for AGF, etc. etc. ...
> 
> The xattr reservation needs to account the following:
> 
> 	- superblock
> 	- agf
> 	- dabtree * maxdepth
> 	- rmtblocks
> 	- ...
> 
> ... '
>

I agree with both the comments. I will try to get the patchset
going in the direction suggested above.

Thanks for taking time to review the patchset.

-- 
chandan



