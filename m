Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EDEC4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 04:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 782EB20872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 04:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r5dJ+J/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392370AbfJQEyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 00:54:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfJQEyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 00:54:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9H4nuOf034490;
        Thu, 17 Oct 2019 04:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Rz3ZAa/BOdUIz5DFVfHUn7sWwN9p4218OKsL4mdwaNU=;
 b=r5dJ+J/2n/eIMAiAZaPBvGTMP49KG7lMIsZyK/Nv3bSCEArVsmax6OyDZzR8YSGjPj4V
 FJad7LHAidid1XgNfe32hbdLOi8qn3A2iMgEzs8hRAAurefVfmmNFMcwUlTvW8A/aXpJ
 PE2NfCVJNMabE6bu9kYIMM0OGPbVm1+9JAVerUFkEUwAFvkt/g9sKVlAEyIMsBbfYnuo
 jF0EPGQWkiX8yEW+0up6uBdTm/+wujPDjtWQY1vzlOHacUOjS1oU8/9QaFRPo/P1M6ZU
 Jk0L8Fiarq432KrzD8p5trIjE8VWwnOTarWb4GTErIeGDm2TlvN5Vvi+uBKi9xRUndKk fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vk6squnh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 04:53:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9H4qvJQ026967;
        Thu, 17 Oct 2019 04:53:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vpf12ypvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 04:53:34 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9H4rVFp008930;
        Thu, 17 Oct 2019 04:53:31 GMT
Received: from localhost (/10.159.241.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Oct 2019 04:53:31 +0000
Date:   Wed, 16 Oct 2019 21:53:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 12/12] xfs: switch to use the new mount-api
Message-ID: <20191017045330.GI13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118650856.9678.4798822571611205029.stgit@fedora-28>
 <20191016181829.GA4870@infradead.org>
 <322766092bbf885ae17eee046c917937f9e76cfc.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <322766092bbf885ae17eee046c917937f9e76cfc.camel@themaw.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910170036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910170035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 09:13:29AM +0800, Ian Kent wrote:
> On Wed, 2019-10-16 at 11:18 -0700, Christoph Hellwig wrote:
> > On Wed, Oct 16, 2019 at 08:41:48AM +0800, Ian Kent wrote:
> > > +static const struct fs_parameter_description xfs_fs_parameters = {
> > > +	.name		= "XFS",
> > > +	.specs		= xfs_param_specs,
> > > +};
> > 
> > Well spell xfs in lower case in the file system type, so I think we
> > should
> > spell it the same here.
> 
> The problem is that this will probably be used in logging later and
> there's a lot of logging that uses the upper case variant.
> 
> OTOH if all the log messages were changed to use lower case "xfs" then
> one of the problems I see with logging (that name inconsistency) would
> go away.
> 
> So I'm not sure what I should do here.

I would just leave it 'XFS' for consistency, but I might be in the back
pocket of Big Letter. ;)

--D

> > 
> > Btw, can we keep all the mount code together where most of it already
> > is at the top of the file?  I know the existing version has some
> > remount
> > stuff at the bottom, but as that get entirely rewritten we might as
> > well
> > move it all up.
> 
> Yep, sounds good.
> 
> > 
> > > +	int			silent = fc->sb_flags & SB_SILENT;
> > 
> > The silent variable is only used once, so we might as well remove it.
> 
> And again.
> 
> > 
> > > +	struct xfs_mount	*mp = fc->s_fs_info;
> > > +
> > > +	/*
> > > +	 * mp and ctx are stored in the fs_context when it is
> > > +	 * initialized. mp is transferred to the superblock on
> > > +	 * a successful mount, but if an error occurs before the
> > > +	 * transfer we have to free it here.
> > > +	 */
> > > +	if (mp) {
> > > +		xfs_free_names(mp);
> > > +		kfree(mp);
> > > +	}
> > 
> > We always pair xfs_free_names with freeing the mount structure.
> > I think it would be nice to add an xfs_free_mount that does both
> > as a refactoring at the beginning of the series. 
> 
> Ditto.
> 
> > 
> > > +static const struct fs_context_operations xfs_context_ops = {
> > > +	.parse_param = xfs_parse_param,
> > > +	.get_tree    = xfs_get_tree,
> > > +	.reconfigure = xfs_reconfigure,
> > > +	.free        = xfs_fc_free,
> > > +};
> > 
> > Should these all get a prefix like xfs_fc_free?  Maybe xfs_fsctx
> > to be a little bit more descriptive?
> 
> Good point, since it's struct fs_context* I think an "xfs_fc_"
> prefix on the context related structures and variables would make
> the most sense.
> 
> I'll do that too.
> Ian
> 
