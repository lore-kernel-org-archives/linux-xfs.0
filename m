Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8522AC282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5283820692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eJmQ4Zbh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgAHQcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:32:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgAHQcm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 11:32:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GSLvA036258;
        Wed, 8 Jan 2020 16:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hQYAHu1SMuwGy8wdNjqciJMZNE9iiJoOhjTqFXOBzBM=;
 b=eJmQ4ZbhufKLw3FNfCUOG3pejAiKOHIxSH/DCExpcfN8fPyzOZ6/BiE9hNHLT2cxIUvU
 +vBUy2+Nn1/D5DePjBrEBG8wtwpmj2kMfNAE6n73gqRH8fXsUd13x/lWdEoP975gR8ns
 s5opuCkcKKS0bQSn/5Id4lhdd88/XQ87ILiPTFEv6h94Fo4J0GYM3R8jjEpOq3gE6Xs9
 aCwxxEtYjWxuEmm0MnCbBTsgYnMgms50R+TiWd+OkWJBMVqa6XAH2rIdU5D4GvGJ1llJ
 s+l0GRX5c/npX+jPgkpbaOEye5jXkHSGo/IAgCcIPiT6mnhjtI0t7KX5mpyFFcTHAYSW rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xakbqvy0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:32:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GSePY092147;
        Wed, 8 Jan 2020 16:32:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xcpct16e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:32:31 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 008GWUaP024512;
        Wed, 8 Jan 2020 16:32:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 08:32:30 -0800
Date:   Wed, 8 Jan 2020 08:32:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200108163229.GE5552@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845710512.84011.14528616369807048509.stgit@magnolia>
 <20200108085402.GC12889@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108085402.GC12889@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 12:54:02AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 07, 2020 at 08:18:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
> > end of struct xfs_buf_log_format.  This makes the size consistent so
> > that we can check it in xfs_ondisk.h, and will be needed once we start
> > logging attribute values.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h |    9 +++++----
> >  fs/xfs/xfs_ondisk.h            |    1 +
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index 8ef31d71a9c7..5d8eb8978c33 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -462,11 +462,12 @@ static inline uint xfs_log_dinode_size(int version)
> >  #define	XFS_BLF_GDQUOT_BUF	(1<<4)
> >  
> >  /*
> > - * This is the structure used to lay out a buf log item in the
> > - * log.  The data map describes which 128 byte chunks of the buffer
> > - * have been logged.
> > + * This is the structure used to lay out a buf log item in the log.  The data
> > + * map describes which 128 byte chunks of the buffer have been logged.  Note
> > + * that XFS_BLF_DATAMAP_SIZE is an odd number so that the structure size will
> > + * be consistent between 32-bit and 64-bit platforms.
> >   */
> > -#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
> > +#define XFS_BLF_DATAMAP_SIZE	(1 + ((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD))
> 
> I don't understand the explanation.  Why would the size differ for
> 32-bit vs 64-bit architectures when it only uses fixed size types?

The structure is 84 bytes in length, which is not an even multiple of 8.
The reason for this is that the end of the structure are 17 unsigned
ints (blf_map_size + blf_map_data).

The blf_blkno field is int64_t, which on amd64 causes the compiler to
round the the structure size up to the nearest 8-byte boundary, or 88
bytes:

/* <1897d> /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_log_format.h:477 */
struct xfs_buf_log_format {
        short unsigned int         blf_type;                                             /*     0     2 */
        short unsigned int         blf_size;                                             /*     2     2 */
        short unsigned int         blf_flags;                                            /*     4     2 */
        short unsigned int         blf_len;                                              /*     6     2 */
        /* typedef int64_t -> s64 -> __s64 */ long long int              blf_blkno;      /*     8     8 */
        unsigned int               blf_map_size;                                         /*    16     4 */
        unsigned int               blf_data_map[17];                                     /*    20    68 */
        /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */

        /* size: 88, cachelines: 2, members: 7 */
        /* last cacheline: 24 bytes */
};

(Same thing with aarch64 and ppc64le gcc.)

i386 gcc doesn't do any of this rounding, so the size is 84 bytes:

/* <182ef> /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_log_format.h:476 */
struct xfs_buf_log_format {
        short unsigned int         blf_type;                                             /*     0     2 */
        short unsigned int         blf_size;                                             /*     2     2 */
        short unsigned int         blf_flags;                                            /*     4     2 */
        short unsigned int         blf_len;                                              /*     6     2 */
        /* typedef int64_t -> s64 -> __s64 */ long long int              blf_blkno;      /*     8     8 */
        unsigned int               blf_map_size;                                         /*    16     4 */
        unsigned int               blf_data_map[16];                                     /*    20    64 */
        /* --- cacheline 1 boundary (64 bytes) was 20 bytes ago --- */

        /* size: 84, cachelines: 2, members: 7 */
        /* last cacheline: 20 bytes */
};

Since we accidentally write to blf_data_map[17] when invalidating a 68k
buffer, that write will corrupt the slab's redzone, or worse, a live
object packed in right after it.

--D
