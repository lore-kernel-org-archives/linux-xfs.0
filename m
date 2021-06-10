Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24924C47094
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 06:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017E2613C8
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 06:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFJGSX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 02:18:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJGSX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 02:18:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A6DxIR056439;
        Thu, 10 Jun 2021 06:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=NipshZPmmLHMzItHlbOklr3c82vbBJmXAWybmus8iY8=;
 b=OyJKaodMopQYUu17NjrAGxbaF1ob5O7e2Dp+QICgNeV1DpKwiRXygWw6ShK7d65x0ngw
 2nhnwsPtthVYqSaASMBXbq1q2pUEWDciuIIklwR6JHsox0PXx1SISLxjitdHeRP2NDL5
 1CPC4AsBBDr4mZ51PMawZc3Qx1lsL3MkT2wT5xxluNmp2HpFMEYdqV8hckXnaMcxS56/
 OWrLH1u5/rHagnY0QZbiGk9aO0pTObZyp0ztofwBZBEXq4wHKqFxkz4NXgjqHrsLYIOy
 Do3aeiE4Z0QA+yCkW683M7bpiscT8MsNJrAikJnsOItCA3gE6xxSpURwS5bSYv9x6LaU Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 39017nk052-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:16:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A6Evwf142834;
        Thu, 10 Jun 2021 06:16:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38yyac9xgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:16:25 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15A6GPrw146308;
        Thu, 10 Jun 2021 06:16:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 38yyac9xgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:16:25 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15A6GOVC016882;
        Thu, 10 Jun 2021 06:16:24 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 23:16:24 -0700
Date:   Thu, 10 Jun 2021 09:16:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dchinner@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: [bug report] xfs: use perag for ialloc btree cursors
Message-ID: <YMGuMliXClE/dz5y@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: 1tvOenxXoEhhKpZfihjXJKbNfWhfczW-
X-Proofpoint-ORIG-GUID: 1tvOenxXoEhhKpZfihjXJKbNfWhfczW-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Dave Chinner,

This is a semi-automatic email about new static checker warnings.

The patch 7b13c5155182: "xfs: use perag for ialloc btree cursors" 
from Jun 2, 2021, leads to the following Smatch complaint:

    fs/xfs/libxfs/xfs_ialloc.c:2403 xfs_imap()
    error: we previously assumed 'pag' could be null (see line 2294)

fs/xfs/libxfs/xfs_ialloc.c
  2286          ASSERT(ino != NULLFSINO);
  2287  
  2288          /*
  2289           * Split up the inode number into its parts.
  2290           */
  2291          pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
  2292          agino = XFS_INO_TO_AGINO(mp, ino);
  2293		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
  2294		if (!pag || agbno >= mp->m_sb.sb_agblocks ||
                     ^^^
Checks for NULL

  2295		    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
  2296			error = -EINVAL;
  2297	#ifdef DEBUG
  2298			/*
  2299			 * Don't output diagnostic information for untrusted inodes
  2300			 * as they can be invalid without implying corruption.
  2301			 */
  2302			if (flags & XFS_IGET_UNTRUSTED)
  2303				goto out_drop;
                                ^^^^^^^^^^^^^

  2304			if (!pag) {
                            ^^^^

  2305				xfs_alert(mp,
  2306					"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
  2307					__func__, XFS_INO_TO_AGNO(mp, ino),
  2308					mp->m_sb.sb_agcount);
  2309			}
  2310			if (agbno >= mp->m_sb.sb_agblocks) {
  2311				xfs_alert(mp,
  2312			"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
  2313					__func__, (unsigned long long)agbno,
  2314					(unsigned long)mp->m_sb.sb_agblocks);
  2315			}
  2316			if (pag && ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
  2317				xfs_alert(mp,
  2318			"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
  2319					__func__, ino,
  2320					XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
  2321			}
  2322			xfs_stack_trace();
  2323	#endif /* DEBUG */
  2324			goto out_drop;
  2325		}
  2326	
  2327		/*
  2328		 * For bulkstat and handle lookups, we have an untrusted inode number
  2329		 * that we have to verify is valid. We cannot do this just by reading
  2330		 * the inode buffer as it may have been unlinked and removed leaving
  2331		 * inodes in stale state on disk. Hence we have to do a btree lookup
  2332		 * in all cases where an untrusted inode number is passed.
  2333		 */
  2334		if (flags & XFS_IGET_UNTRUSTED) {
  2335			error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
  2336						&chunk_agbno, &offset_agbno, flags);
  2337			if (error)
  2338				goto out_drop;
  2339			goto out_map;
  2340		}
  2341	
  2342		/*
  2343		 * If the inode cluster size is the same as the blocksize or
  2344		 * smaller we get to the buffer by simple arithmetics.
  2345		 */
  2346		if (M_IGEO(mp)->blocks_per_cluster == 1) {
  2347			offset = XFS_INO_TO_OFFSET(mp, ino);
  2348			ASSERT(offset < mp->m_sb.sb_inopblock);
  2349	
  2350			imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, agbno);
  2351			imap->im_len = XFS_FSB_TO_BB(mp, 1);
  2352			imap->im_boffset = (unsigned short)(offset <<
  2353								mp->m_sb.sb_inodelog);
  2354			error = 0;
  2355			goto out_drop;
  2356		}
  2357	
  2358		/*
  2359		 * If the inode chunks are aligned then use simple maths to
  2360		 * find the location. Otherwise we have to do a btree
  2361		 * lookup to find the location.
  2362		 */
  2363		if (M_IGEO(mp)->inoalign_mask) {
  2364			offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
  2365			chunk_agbno = agbno - offset_agbno;
  2366		} else {
  2367			error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
  2368						&chunk_agbno, &offset_agbno, flags);
  2369			if (error)
  2370				goto out_drop;
  2371		}
  2372	
  2373	out_map:
  2374		ASSERT(agbno >= chunk_agbno);
  2375		cluster_agbno = chunk_agbno +
  2376			((offset_agbno / M_IGEO(mp)->blocks_per_cluster) *
  2377			 M_IGEO(mp)->blocks_per_cluster);
  2378		offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
  2379			XFS_INO_TO_OFFSET(mp, ino);
  2380	
  2381		imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, cluster_agbno);
  2382		imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
  2383		imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
  2384	
  2385		/*
  2386		 * If the inode number maps to a block outside the bounds
  2387		 * of the file system then return NULL rather than calling
  2388		 * read_buf and panicing when we get an error from the
  2389		 * driver.
  2390		 */
  2391		if ((imap->im_blkno + imap->im_len) >
  2392		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
  2393			xfs_alert(mp,
  2394		"%s: (im_blkno (0x%llx) + im_len (0x%llx)) > sb_dblocks (0x%llx)",
  2395				__func__, (unsigned long long) imap->im_blkno,
  2396				(unsigned long long) imap->im_len,
  2397				XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
  2398			error = -EINVAL;
  2399			goto out_drop;
  2400		}
  2401		error = 0;
  2402	out_drop:
  2403		xfs_perag_put(pag);
                              ^^^
Dereferenced inside the function call

  2404		return error;
  2405	}

regards,
dan carpenter
