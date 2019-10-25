Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C3ECA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9959721D71
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ak5ugnXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407831AbfJYQjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:39:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409568AbfJYQjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:39:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PGd4dE149188;
        Fri, 25 Oct 2019 16:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=g+xffPqb5xRNHs5pAzJA9dNM6QEikrAvzEmoyo/Obrk=;
 b=Ak5ugnXuPpor7yEtZrCLWvSfE4tQ7g9fQ02pziDkkpmEmeQmkGrfM21/Uj+pGD8+XlvB
 hY+GdS4nCFQqLff3qskg4aCtQ7GfJOyOhdrMsujJd2k/WbmqIeDdnNL5jYeL+DbVMZq7
 H5BaGoNxRUw6jn5gv/x2Qmc4sa6GN1AKn8xVe6X+0cfGuqYm3UuwAGE7Z3bOM4D3IHIt
 W3x0wjN7Y+6eKxb4gvYlYBkrxE8Ur+HdEI+MYz194cENcg60x42prGfTt3O6cVtp+ELa
 5erQBjQUbMoDnouXBHErJZ+L6Dqjs8rO3v5BuIhbzOy/iFyKm1obB+ygXFlhDE2EbkCI MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswu4c4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:39:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PGcZZM072603;
        Fri, 25 Oct 2019 16:39:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vunbmrsxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:39:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9PGd5ma010764;
        Fri, 25 Oct 2019 16:39:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 09:39:04 -0700
Date:   Fri, 25 Oct 2019 09:39:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <20191025163904.GL913374@magnolia>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
 <157063979364.2914891.5142110960507331172.stgit@magnolia>
 <20191025141947.GA11837@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025141947.GA11837@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 10:19:47AM -0400, Brian Foster wrote:
> On Wed, Oct 09, 2019 at 09:49:53AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add some debug knobs so that we can control the leaf and node block
> > slack when rebuilding btrees.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_globals.c |    6 ++++++
> >  fs/xfs/xfs_sysctl.h  |    2 ++
> >  fs/xfs/xfs_sysfs.c   |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 62 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> > index fa55ab8b8d80..8f67027c144b 100644
> > --- a/fs/xfs/xfs_globals.c
> > +++ b/fs/xfs/xfs_globals.c
> > @@ -43,4 +43,10 @@ struct xfs_globals xfs_globals = {
> >  #ifdef DEBUG
> >  	.pwork_threads		=	-1,	/* automatic thread detection */
> >  #endif
> > +
> > +	/* Bulk load new btree leaf blocks to 75% full. */
> > +	.bload_leaf_slack	=	-1,
> > +
> > +	/* Bulk load new btree node blocks to 75% full. */
> > +	.bload_node_slack	=	-1,
> 
> What are the units for these fields?

Records (or key/ptr pairs).

> Seems reasonable outside of that, though I'd probably reorder it to
> after the related code such that this patch also includes whatever
> bits that actually use the fields.

It's the next patch.  Will reorder.

Thanks for reviewing!  I totally replied to these in reverse redro! :)

--D

> Brian
> 
> >  };
> > diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> > index 8abf4640f1d5..aecccceee4ca 100644
> > --- a/fs/xfs/xfs_sysctl.h
> > +++ b/fs/xfs/xfs_sysctl.h
> > @@ -85,6 +85,8 @@ struct xfs_globals {
> >  #ifdef DEBUG
> >  	int	pwork_threads;		/* parallel workqueue threads */
> >  #endif
> > +	int	bload_leaf_slack;	/* btree bulk load leaf slack */
> > +	int	bload_node_slack;	/* btree bulk load node slack */
> >  	int	log_recovery_delay;	/* log recovery delay (secs) */
> >  	int	mount_delay;		/* mount setup delay (secs) */
> >  	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index f1bc88f4367c..673ad21a9585 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -228,6 +228,58 @@ pwork_threads_show(
> >  XFS_SYSFS_ATTR_RW(pwork_threads);
> >  #endif /* DEBUG */
> >  
> > +STATIC ssize_t
> > +bload_leaf_slack_store(
> > +	struct kobject	*kobject,
> > +	const char	*buf,
> > +	size_t		count)
> > +{
> > +	int		ret;
> > +	int		val;
> > +
> > +	ret = kstrtoint(buf, 0, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	xfs_globals.bload_leaf_slack = val;
> > +	return count;
> > +}
> > +
> > +STATIC ssize_t
> > +bload_leaf_slack_show(
> > +	struct kobject	*kobject,
> > +	char		*buf)
> > +{
> > +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_leaf_slack);
> > +}
> > +XFS_SYSFS_ATTR_RW(bload_leaf_slack);
> > +
> > +STATIC ssize_t
> > +bload_node_slack_store(
> > +	struct kobject	*kobject,
> > +	const char	*buf,
> > +	size_t		count)
> > +{
> > +	int		ret;
> > +	int		val;
> > +
> > +	ret = kstrtoint(buf, 0, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	xfs_globals.bload_node_slack = val;
> > +	return count;
> > +}
> > +
> > +STATIC ssize_t
> > +bload_node_slack_show(
> > +	struct kobject	*kobject,
> > +	char		*buf)
> > +{
> > +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_node_slack);
> > +}
> > +XFS_SYSFS_ATTR_RW(bload_node_slack);
> > +
> >  static struct attribute *xfs_dbg_attrs[] = {
> >  	ATTR_LIST(bug_on_assert),
> >  	ATTR_LIST(log_recovery_delay),
> > @@ -236,6 +288,8 @@ static struct attribute *xfs_dbg_attrs[] = {
> >  #ifdef DEBUG
> >  	ATTR_LIST(pwork_threads),
> >  #endif
> > +	ATTR_LIST(bload_leaf_slack),
> > +	ATTR_LIST(bload_node_slack),
> >  	NULL,
> >  };
> >  
> > 
> 
