Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463E6C433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 02:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D41A206C1
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 02:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y+EWSuG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGYCtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:49:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYCtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 22:49:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lAMh077071;
        Sat, 25 Jul 2020 02:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hmu7l6cmMxrfuWgNK9enHL/AaZgv7tJaubrwXxvCOxw=;
 b=y+EWSuG+h9kZwUgnFXYOx5mjnCbmB+iK9sEIoMgBAc153zQyWPxs1dBfSM12UhQ6DmxI
 y2l8iRQkKNttxtqk6ta33X+Ug+8DwfZdJQxr6FQOs+o7yCVf84QbMAKgL7I9RF431orl
 zIlYp7vgZHhwRCJsrp2cqZ/kmFZLY4P/fVrXjN1YdztbdrTvEsQI6mIIUBDtXjpUQf90
 mfcBl+o7oivOgNiSKTwpx0u7dBFxp1BtiLHZTeNjYdR9uB/aER2YmxXH4Z+Joml6A2VB
 QwFT7UfHK80+ujEElFKl/Vjx0Mw705ilCHnOfS/0OlKbvSfZHWjynO0JFVDvCmmAGiik 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32gc5qr0ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:49:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mdH9092551;
        Sat, 25 Jul 2020 02:49:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32gaseaqnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:49:46 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2njmW003741;
        Sat, 25 Jul 2020 02:49:45 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 19:49:45 -0700
Subject: Re: [PATCH v11 01/25] xfs: Add xfs_has_attr and subroutines
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-2-allison.henderson@oracle.com>
 <20200721232613.GZ7625@magnolia> <20200724022436.GM2005@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3ebfc541-79e2-68b2-d5ee-71b5424f1e61@oracle.com>
Date:   Fri, 24 Jul 2020 19:49:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724022436.GM2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/23/20 7:24 PM, Dave Chinner wrote:
> On Tue, Jul 21, 2020 at 04:26:13PM -0700, Darrick J. Wong wrote:
>> On Mon, Jul 20, 2020 at 05:15:42PM -0700, Allison Collins wrote:
>>> This patch adds a new functions to check for the existence of an
>>> attribute. Subroutines are also added to handle the cases of leaf
>>> blocks, nodes or shortform. Common code that appears in existing attr
>>> add and remove functions have been factored out to help reduce the
>>> appearance of duplicated code.  We will need these routines later for
>>> delayed attributes since delayed operations cannot return error codes.
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>
>> Looks good enough for now... I still dislike generating ENOATTR/EEXIST
>> deep in the folds of the attr code but that's probably a bigger thing to
>> be wrangled with later.  (And tbh I've thought about this & haven't come
>> up with a better idea anyway :P)
> 
> Yes, I agree it is hard to read, but I do think there's a cleaner
> way of doing this. Take, for example, xfs_attr_leaf_try_add(). It
> looks like this:
> 
>          /*
>           * Look up the given attribute in the leaf block.  Figure out if
>           * the given flags produce an error or call for an atomic rename.
>           */
>          retval = xfs_attr_leaf_hasname(args, &bp);
>          if (retval != -ENOATTR && retval != -EEXIST)
>                  return retval;
>          if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>                  goto out_brelse;
>          if (retval == -EEXIST) {
>                  if (args->attr_flags & XATTR_CREATE)
>                          goto out_brelse;
> 
>                  trace_xfs_attr_leaf_replace(args);
> 
>                  /* save the attribute state for later removal*/
>                  args->op_flags |= XFS_DA_OP_RENAME;     /* an atomic rename */
>                  xfs_attr_save_rmt_blk(args);
> 
>                  /*
>                   * clear the remote attr state now that it is saved so that the
>                   * values reflect the state of the attribute we are about to
>                   * add, not the attribute we just found and will remove later.
>                   */
>                  args->rmtblkno = 0;
>                  args->rmtblkcnt = 0;
>                  args->rmtvaluelen = 0;
>          }
> 
>          /*
>           * Add the attribute to the leaf block
>           */
>          return xfs_attr3_leaf_add(bp, args);
> 
> out_brelse:
>          xfs_trans_brelse(args->trans, bp);
>          return retval;
> }
> 
> 
> I agree, the error handling is messy and really hard to follow.
> But if we write it like this:
> 
>          /*
>           * Look up the given attribute in the leaf block.  Figure out if
>           * the given flags produce an error or call for an atomic rename.
>           */
>          retval = xfs_attr_leaf_hasname(args, &bp);
>          switch (retval) {
>          case -ENOATTR:
>                  if (args->attr_flags & XATTR_REPLACE)
>                          goto out_brelse;
>                  break;
>          case -EEXIST:
>                  if (args->attr_flags & XATTR_CREATE)
>                          goto out_brelse;
> 
>                  trace_xfs_attr_leaf_replace(args);
> 
>                  /* save the attribute state for later removal*/
>                  args->op_flags |= XFS_DA_OP_RENAME;     /* an atomic rename */
>                  xfs_attr_save_rmt_blk(args);
> 
>                  /*
>                   * clear the remote attr state now that it is saved so that the
>                   * values reflect the state of the attribute we are about to
>                   * add, not the attribute we just found and will remove later.
>                   */
>                  args->rmtblkno = 0;
>                  args->rmtblkcnt = 0;
>                  args->rmtvaluelen = 0;
>                  break;
> 	case 0:
> 		break;
>          default:
>                  return retval;
>          }
> 
>          /*
>           * Add the attribute to the leaf block
>           */
>          return xfs_attr3_leaf_add(bp, args);
> 
> out_brelse:
>          xfs_trans_brelse(args->trans, bp);
>          return retval;
> }
> 
> The logic is *much* cleaner and it is not overly verbose, either.
> This sort of change could be done at the end of the series, too,
> rather than requiring a rebase of everything....

Sure, I know this one had quite a bit of ping pong before it landed 
where it did.  I am not opposed to later rearranging it as long as the 
underlying mechanics are the same.  :-)

Allison
> 
> Cheers,
> 
> Dave.
> 
