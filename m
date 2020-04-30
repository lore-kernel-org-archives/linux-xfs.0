Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5237BC83003
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 02:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C0320787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 02:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgD3C0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 22:26:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgD3C0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 22:26:32 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U22dxJ051009;
        Wed, 29 Apr 2020 22:26:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqaa4xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 22:26:12 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03U2ItK9132628;
        Wed, 29 Apr 2020 22:26:12 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqaa4wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 22:26:11 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03U2M8O9030748;
        Thu, 30 Apr 2020 02:26:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7x732-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 02:26:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03U2Q74m60228084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:26:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38BDBA4054;
        Thu, 30 Apr 2020 02:26:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5270A4066;
        Thu, 30 Apr 2020 02:26:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.49.51])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 02:26:05 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Thu, 30 Apr 2020 07:59:08 +0530
Message-ID: <2849442.pQ9utvUBtc@localhost.localdomain>
Organization: IBM
In-Reply-To: <20200427073948.GA15777@infradead.org>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <20200404085203.1908-3-chandanrlinux@gmail.com> <20200427073948.GA15777@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_01:2020-04-30,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=1
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday, April 27, 2020 1:09 PM Christoph Hellwig wrote: 
> FYI, I have had a series in the works for a while but not quite 
> finished yet that moves the in-memory nextents and format fields
> into the ifork structure.  I feared this might conflict badly, but
> so far this seems relatively harmless.  Note that your patch creates
> some not so nice layout in struct xfs_icdinode, so maybe I need to
> rush and finish that series ASAP.
> 
> > +static inline int32_t XFS_DFORK_NEXTENTS(struct xfs_sb *sbp,
> > +					struct xfs_dinode *dip, int whichfork)
> > +{
> > +	int32_t anextents;
> > +
> > +	if (whichfork == XFS_DATA_FORK)
> > +		return be32_to_cpu((dip)->di_nextents);
> > +
> > +	anextents = be16_to_cpu((dip)->di_anextents_lo);
> > +	if (xfs_sb_version_has_v3inode(sbp))
> > +		anextents |= ((u32)(be16_to_cpu((dip)->di_anextents_hi)) << 16);
> > +
> > +	return anextents;
> 
> No need for any of the braces around dip.  Also this funcion really
> deserves a proper lower case name now, and probably should be moved out
> of line.

Sure, I will implement that.

> 
> >  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> >  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> >  typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> > -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> > +typedef int32_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> 
> We can just retire xfs_aextnum_t.  It only has 4 uses anyway.
> 
> > @@ -327,7 +327,7 @@ xfs_inode_to_log_dinode(
> >  	to->di_nblocks = from->di_nblocks;
> >  	to->di_extsize = from->di_extsize;
> >  	to->di_nextents = from->di_nextents;
> > -	to->di_anextents = from->di_anextents;
> > +	to->di_anextents_lo = ((u32)(from->di_anextents)) & 0xffff;
> 
> No need for any of the casting here.

Ok.

> 
> > @@ -3044,7 +3045,14 @@ xlog_recover_inode_pass2(
> >  			goto out_release;
> >  		}
> >  	}
> > -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> > +
> > +	nextents = ldip->di_anextents_lo;
> > +	if (xfs_sb_version_has_v3inode(&mp->m_sb))
> > +		nextents |= ((u32)(ldip->di_anextents_hi) << 16);
> > +
> > +	nextents += ldip->di_nextents;
> 
> Little helpers to get/set the attr extents in the log inode would be nice.
>

Ok. I will implement the helper functions.

> 
> Last but not least:  This seems like a feature flag we could just lazily
> set once needed, similar to attr2.
> 

Yes, I will implement this change before posting the next version of the
patchset.

-- 
chandan



