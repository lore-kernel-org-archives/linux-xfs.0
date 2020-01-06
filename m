Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EA9C33C8C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 21:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 215472080A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 21:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S/TbtfzH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAFVpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 16:45:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgAFVpd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 16:45:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006LjANE194891;
        Mon, 6 Jan 2020 21:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=W4CBj7C3TbSH/75Nihvg75bWZS8eL/PIz0YPT0ku420=;
 b=S/TbtfzHGgFeMRQOkUrqb/lM8hZ04VonXg7dcFUOSNxZrz7lQYq6hILjOXMmSKb4Dcll
 D2KuZ+5pbd/IJcBPsXeNSS6prNOc1c9u1elDTBvjfU2SK1Ri3vQU17rsbdOeVrrF1JAM
 wEV5cFvjGUm/8/zVZWyOhdXeMg9qshwuhIitonOClZ7Nr9giXPFPcM33QLVcFhTBh011
 YlLdqELs9ZGNKUWqJzOQ57RTjp9yO9DEgeJx2q0hzHh/hQAZkVo2AQjX6atHv2DjGM0v
 pOKflxT8RK8PO9h/FZvO4Ej7dmrHEdH2zhzm+3EnAhm+4CQ9y8n5AWUu+3Y+XU6/VUrO ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xajnpst04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 21:45:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006LiJ8U107526;
        Mon, 6 Jan 2020 21:45:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xb4uppsuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 21:45:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 006Lj2Br017181;
        Mon, 6 Jan 2020 21:45:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 13:45:02 -0800
Date:   Mon, 6 Jan 2020 13:45:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 05/14] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20200106214500.GA472651@magnolia>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-6-allison.henderson@oracle.com>
 <20191224121410.GB18379@infradead.org>
 <07284127-d9d7-e3eb-8e25-396e36ffaa93@oracle.com>
 <20200106144650.GB6799@bfoster>
 <af903a9f-2e2c-ac21-37a4-093be64f113d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af903a9f-2e2c-ac21-37a4-093be64f113d@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001060182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001060182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 06, 2020 at 11:29:29AM -0700, Allison Collins wrote:
> 
> 
> On 1/6/20 7:46 AM, Brian Foster wrote:
> > On Wed, Dec 25, 2019 at 10:43:15AM -0700, Allison Collins wrote:
> > > 
> > > 
> > > On 12/24/19 5:14 AM, Christoph Hellwig wrote:
> > > > On Wed, Dec 11, 2019 at 09:15:04PM -0700, Allison Collins wrote:
> > > > > Break xfs_attr_rmtval_set into two helper functions
> > > > > xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> > > > > xfs_attr_rmtval_set rolls the transaction between the
> > > > > helpers, but delayed operations cannot.  We will use
> > > > > the helpers later when constructing new delayed
> > > > > attribute routines.
> > > > 
> > > > Please use up the foll 72-ish characters for the changelog (also for
> > > > various other patches).
> > > Hmm, in one of my older reviews, we thought the standard line wrap length
> > > was 68.  Maybe when more folks get back from holiday break, we can have more
> > > chime in here.
> > > 
> > 
> > I thought it was 68 as well (I think that qualifies as 72-ish" at
> > least), but the current commit logs still look short of that at a
> > glance. ;P
> > 
> > Brian
> Ok I doubled checked, the last few lines do wrap a little early, but the
> rest is correct for 68 because of the function names.  We should probably
> establish a number though.  In perusing around some of the other patches on
> the list, it looks to me like people are using 81?

I use 72 columns for emails and commit messages, and 79 for code.

Though to be honest that's just my editor settings; I'm sure interested
parties could find plenty of instances where my enforcement of even that
is totally lax --

I have enough of a difficult time finding all the subtle bugs and corner
case design problems in the kernel code (which will cause problems in
our users' lives) that so long as you're not obviously going past the
flaming red stripe that I told vim to put at column 80, I don't really
care (because maxcolumns errors don't usually cause data loss). :)

(Not trying to say that peoples' code is crap, I'm just laying out where
I put maxcolumns in my priority barrel.)

--D

> 
> Allison
> 
> > 
> > > > 
> > > > For the actual patch: can you keep the code in the order of the calling
> > > > conventions, that is the lower level functions up and
> > > > xfs_attr_rmtval_set at the bottom?  Also please keep the functions
> > > > static until callers show up (which nicely leads to the above order).
> > > > 
> > > 
> > > Sure, will do.
> > > 
> > > Allison
> > > 
> > 
