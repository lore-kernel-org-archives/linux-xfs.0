Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFDBC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 17:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F99220672
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 17:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QMrGsbSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgG1RtU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 13:49:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbgG1RtT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 13:49:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SHc5ar075252
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 17:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+HB5pvbXh39Mft2tVd/IIlDsgLYWJyJnPKvhej8uwDs=;
 b=QMrGsbSnVXpVnPgiYCdQSm7R9Pik94Bp9BBSkii5U9DHJ/7zHhc+MCAOC0Y7B7C0tuzF
 +pbovi1WMteB+f+DP6dccE10JTtFdhfDNMlS1gKV9sAPoLsSnvBaoLDy2dMBFEnmviQH
 frPd5uMRjcWnXKu2Cm9u6Lxi2xYril7ESBYpRqTiZMHUo5mt7iR26Rodr0zkWlItagdT
 5XH1OS7bdTtI0hwrHW+ybM+th6Uu23ZcLFtMlcXlc89Qf67ytN67UT4J4q+4mwJOkNrE
 MAOcXX3Q1EoRPZBlwVtz9qS1XPEjoySCcwlcX+yKLK4WNKOWDcdlyZcdufYNsMmqu1UD bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32hu1j8yj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 17:49:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SHWjbN162368
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 17:49:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32hu5ug62x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 17:49:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06SHnIfS016324
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 17:49:18 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 10:49:17 -0700
Subject: Re: [bug report] xfs: Add xfs_has_attr and subroutines
To:     dan.carpenter@oracle.com
Cc:     linux-xfs@vger.kernel.org
References: <20200728115752.GA426300@mwanda>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <487b69f6-b9a2-7fd1-23cb-defcb2eb033c@oracle.com>
Date:   Tue, 28 Jul 2020 10:49:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728115752.GA426300@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=895
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=881
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=4 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/20 4:57 AM, dan.carpenter@oracle.com wrote:
> Hello Allison Collins,
> 
> The patch cfe3d8821c6f: "xfs: Add xfs_has_attr and subroutines" from
> Jul 20, 2020, leads to the following Smatch warning:
> 
> 	fs/xfs/libxfs/xfs_attr.c:1431 xfs_attr_node_get()
> 	warn: variable dereferenced before check 'state' (see line 1426)
> 
> fs/xfs/libxfs/xfs_attr.c
>    1398  STATIC int
>    1399  xfs_attr_node_get(
>    1400          struct xfs_da_args      *args)
>    1401  {
>    1402          struct xfs_da_state     *state;
>    1403          struct xfs_da_state_blk *blk;
>    1404          int                     i;
>    1405          int                     error;
>    1406
>    1407          trace_xfs_attr_node_get(args);
>    1408
>    1409          /*
>    1410           * Search to see if name exists, and get back a pointer to it.
>    1411           */
>    1412          error = xfs_attr_node_hasname(args, &state);
>    1413          if (error != -EEXIST)
>    1414                  goto out_release;
>                          ^^^^^^^^^^^^^^^^
> state can be NULL.
> 
>    1415
>    1416          /*
>    1417           * Get the value, local or "remote"
>    1418           */
>    1419          blk = &state->path.blk[state->path.active - 1];
>    1420          error = xfs_attr3_leaf_getvalue(blk->bp, args);
>    1421
>    1422          /*
>    1423           * If not in a transaction, we have to release all the buffers.
>    1424           */
>    1425  out_release:
>    1426          for (i = 0; i < state->path.active; i++) {
>                                  ^^^^^^^^^^^^^^^^^^
> Dereference
> 
>    1427                  xfs_trans_brelse(args->trans, state->path.blk[i].bp);
>    1428                  state->path.blk[i].bp = NULL;
>    1429          }
>    1430
>    1431          if (state)
>                      ^^^^^
> To late.
> 
>    1432                  xfs_da_state_free(state);
>    1433          return error;
>    1434  }
> 
> regards,
> dan carpenter
> 
Thanks for the catch, with send a patch for this

Allison
