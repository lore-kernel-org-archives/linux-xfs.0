Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150E1C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 12:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C972071E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 12:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgDYMEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 08:04:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgDYMEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 08:04:46 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03PC2Txa033890;
        Sat, 25 Apr 2020 08:04:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhq5bhyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 08:04:42 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03PC3coI040476;
        Sat, 25 Apr 2020 08:04:41 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhq5bhy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 08:04:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03PBxnuf005302;
        Sat, 25 Apr 2020 12:04:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5get4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 12:04:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03PC4b9f60948768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 12:04:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 305ECA4040;
        Sat, 25 Apr 2020 12:04:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA2E6A404D;
        Sat, 25 Apr 2020 12:04:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.88.173])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 25 Apr 2020 12:04:35 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Sat, 25 Apr 2020 17:37:39 +0530
Message-ID: <2457302.TnqmriUJk8@localhost.localdomain>
Organization: IBM
In-Reply-To: <20200422223041.GE27860@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <2468041.fvziTNUSPq@localhost.localdomain> <20200422223041.GE27860@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-25_06:2020-04-24,2020-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=1
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004250102
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, April 23, 2020 4:00 AM Dave Chinner wrote: 
> On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> > On Monday, April 20, 2020 10:08 AM Chandan Rajendra wrote: 
> > > On Tuesday, April 14, 2020 12:25 AM Darrick J. Wong wrote: 
> > > > That said, it was very helpful to point out that the current MAXEXTNUM /
> > > > MAXAEXTNUM symbols stop short of using all 32 (or 16) bits.
> > > > 
> > > > Can we use this new feature flag + inode flag to allow 4294967295
> > > > extents in either fork?
> > > 
> > > Sure.
> > > 
> > > I have already tested that having 4294967295 as the maximum data extent count
> > > does not cause any regressions.
> > > 
> > > Also, Dave was of the opinion that data extent counter be increased to
> > > 64-bit. I think I should include that change along with this feature flag
> > > rather than adding a new one in the near future.
> > > 
> > > 
> > 
> > Hello Dave & Darrick,
> > 
> > Can you please look into the following design decision w.r.t using 32-bit and
> > 64-bit unsigned counters for xattr and data extents.
> > 
> > Maximum extent counts.
> > |-----------------------+----------------------|
> > | Field width (in bits) |          Max extents |
> > |-----------------------+----------------------|
> > |                    32 |           4294967295 |
> > |                    48 |      281474976710655 |
> > |                    64 | 18446744073709551615 |
> > |-----------------------+----------------------|
> 
> These huge numbers are impossible to compare visually.  Once numbers
> go beyond 7-9 digits, you need to start condensing them in reports.
> Humans are, in general, unable to handle strings of digits longer
> than 7-9 digits at all well...
> 
> Can you condense them by using scientific representation i.e. XEy,
> which gives:
> 
> |-----------------------+-------------|
> | Field width (in bits) | Max extents |
> |-----------------------+-------------|
> |                    32 |      4.3E09 |
> |                    48 |      2.8E14 |
> |                    64 |      1.8E19 |
> |-----------------------+-------------|
> 
> It's much easier to compare differences visually because it's not
> only 4 digits, not 20. The other alternative is to use k,m,g,t,p,e
> suffixes to indicate magnitude (4.3g, 280t, 18e), but using
> exponentials make the numbers easier to do calculations on
> directly...
>

Sorry about that. I will use scientific notation for representing large
numbers.

> > |-------------------+-----|
> > | Minimum node recs | 125 |
> > | Minimum leaf recs | 125 |
> > |-------------------+-----|
>

Yes, your assumption of 4k block size is correct. I will include detailed
calculation steps in my future mails.

> Please show your working. I'm assuming this is 50% * 4kB /
> sizeof(bmbt_rec), so you are working out limits based on 4kB block
> size? Realistically, worse case behaviour will be with the minimum
> supported block size, which in this case will be 1kB....
> 
> > Data bmbt tree height (MINDBTPTRS == 3)
> > |-------+------------------------+-------------------------|
> > | Level | Number of nodes/leaves |           Total Nr recs |
> > |       |                        | (nr nodes/leaves * 125) |
> > |-------+------------------------+-------------------------|
> > |     0 |                      1 |                       3 |
> > |     1 |                      3 |                     375 |
> > |     2 |                    375 |                   46875 |
> > |     3 |                  46875 |                 5859375 |
> > |     4 |                5859375 |               732421875 |
> > |     5 |              732421875 |             91552734375 |
> > |     6 |            91552734375 |          11444091796875 |
> > |     7 |         11444091796875 |        1430511474609375 |
> > |     8 |       1430511474609375 |      178813934326171875 |
> > |     9 |     178813934326171875 |    22351741790771484375 |
> > |-------+------------------------+-------------------------|
> > 
> > For counting data extents, even though we theoretically have 64 bits at our
> > disposal, I think we should have (2 ** 48) - 1 as the maximum number of
> > extents. This gives 281474976710655 (i.e. ~281 trillion extents). With this,
> > bmbt tree's height grows by just two more levels (i.e. it grows from the
> > current maximum height of 5 to 7). Please let me know your opinion on this.
> 
> We shouldn't make up arbitrary limits when we can calculate them exactly.
> i.e. 2^63 max file size, 1kB block size (2^10), means max fragments
> is 2^53 entries. On a 64kB block size (2^16), we have a max extent
> count of 2^47....
> 
> i.e. 2^48 would be an acceptible limit for 1kB block size, but it is
> not correct for 64kB block size filesystems....

You are right about this. I will set the max data extent count to 2^47.

> 
> > Attr bmbt tree height (MINABTPTRS == 2)
> > |-------+------------------------+-------------------------|
> > | Level | Number of nodes/leaves |           Total Nr recs |
> > |       |                        | (nr nodes/leaves * 125) |
> > |-------+------------------------+-------------------------|
> > |     0 |                      1 |                       2 |
> > |     1 |                      2 |                     250 |
> > |     2 |                    250 |                   31250 |
> > |     3 |                  31250 |                 3906250 |
> > |     4 |                3906250 |               488281250 |
> > |     5 |              488281250 |             61035156250 |
> > |-------+------------------------+-------------------------|
> > 
> > For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> > will cause the corresponding bmbt's maximum height to go from 3 to 5.
> > This probably won't cause any regression.
> 
> We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
> attr fork extent count makes no difference to the attribute fork
> bmbt reservations. i.e. the bmbt reservations are defined by the
> dabtree structure limits, not the maximum extent count the fork can
> hold.

I think the dabtree structure limits is because of the following ...

How many levels of dabtree would be needed to hold ~100 million xattrs?
- name len = 16 bytes
         struct xfs_parent_name_rec {
               __be64  p_ino;
               __be32  p_gen;
               __be32  p_diroffset;
       };
  i.e. 64 + 32 + 32 = 128 bits = 16 bytes;
- Value len = file name length = Assume ~40 bytes
- Formula for number of node entries (used in column 3 in the table given
  below) at any level of the dabtree,
  nr_blocks * ((block size - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct
  xfs_da_node_entry))
  i.e. nr_blocks * ((block size - 64) / 8)
- Formula for number of leaf entries (used in column 4 in the table given
  below),
  (block size - sizeof(xfs_attr_leaf_hdr_t)) /
  (sizeof(xfs_attr_leaf_entry_t) + valuelen + namelen + nameval)
  i.e. nr_blocks * ((block size - 32) / (8 + 2 + 1 + 16 + 40))

Here I have assumed block size to be 4k.

|-------+------------------+--------------------------+--------------------------|
| Level | Number of blocks | Number of entries (node) | Number of entries (leaf) |
|-------+------------------+--------------------------+--------------------------|
|     0 |              1.0 |                      5e2 |                    6.1e1 |
|     1 |              5e2 |                    2.5e5 |                    3.0e4 |
|     2 |            2.5e5 |                    1.3e8 |                    1.5e7 |
|     3 |            1.3e8 |                   6.6e10 |                    7.9e9 |
|-------+------------------+--------------------------+--------------------------|

Hence we would need a tree of height 3.
Total number of blocks = 1 + 5e2 + 2.5e5 + 1.3e8 = ~1.3e8
... which is < 2^32 (4.3e9)

> 
> The data fork to 64 bits has no impact on the directory
> reservations, either, because the number of extents in the directory
> is bound by the directory segment size of 32GB. i.e. a directory can
> hold, at most, 32GB of dirent data, which means there's a hard limit
> on the number of dabtree entries somewhere in the order of a few
> hundred million. That's where XFS_DA_NODE_MAXDEPTH comes from - it's
> large enough to index a max sized directory, and the BMBT overhead
> is derived from that...

Ok. Thanks for explaining that.

> 
> > Meanwhile, I will work on finding the impact of increasing the
> > height of these two trees on log reservation.
> 
> It should not change it substantially - 2 blocks per bmbt
> reservation per transaction is what I'd expect from the numbers
> presented...

I still haven't got to this task yet. I will respond soon. I spent time in
figuring out how directories are organized in XFS and also arriving at the
above mentioned calculations for xattr extent counter. 

-- 
chandan



