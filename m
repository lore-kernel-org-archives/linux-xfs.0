Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2546ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9F3F20684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PpuQ4XDT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfJYOUJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:20:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29348 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729544AbfJYOUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572013202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqX7OnsCvRXGJHQti6Hjt36MRfOJRu1ekXjAfyjz+0U=;
        b=PpuQ4XDTFhwxn5U11b1FgfOT1AmimVt2o+Aoaox0hnCKmeXOl+2pAd56EbYEPQf7A336g5
        Eu7KeR4EbDARak6GSG0cEyslH/+bjtQJDQV89ID+Fkkk7ccKK23fE1ZPGQCcfacPn1ptEE
        tbkLlXivjdkU8nm12lDAc87ZR4fbxhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-P8bH_IP6PuucJR2biZN-HQ-1; Fri, 25 Oct 2019 10:19:54 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A04B4107AD31;
        Fri, 25 Oct 2019 14:19:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 478671001B2D;
        Fri, 25 Oct 2019 14:19:49 +0000 (UTC)
Date:   Fri, 25 Oct 2019 10:19:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <20191025141947.GA11837@bfoster>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
 <157063979364.2914891.5142110960507331172.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063979364.2914891.5142110960507331172.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: P8bH_IP6PuucJR2biZN-HQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add some debug knobs so that we can control the leaf and node block
> slack when rebuilding btrees.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_globals.c |    6 ++++++
>  fs/xfs/xfs_sysctl.h  |    2 ++
>  fs/xfs/xfs_sysfs.c   |   54 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 62 insertions(+)
>=20
>=20
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index fa55ab8b8d80..8f67027c144b 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -43,4 +43,10 @@ struct xfs_globals xfs_globals =3D {
>  #ifdef DEBUG
>  =09.pwork_threads=09=09=3D=09-1,=09/* automatic thread detection */
>  #endif
> +
> +=09/* Bulk load new btree leaf blocks to 75% full. */
> +=09.bload_leaf_slack=09=3D=09-1,
> +
> +=09/* Bulk load new btree node blocks to 75% full. */
> +=09.bload_node_slack=09=3D=09-1,

What are the units for these fields? Seems reasonable outside of that,
though I'd probably reorder it to after the related code such that this
patch also includes whatever bits that actually use the fields.

Brian

>  };
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 8abf4640f1d5..aecccceee4ca 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -85,6 +85,8 @@ struct xfs_globals {
>  #ifdef DEBUG
>  =09int=09pwork_threads;=09=09/* parallel workqueue threads */
>  #endif
> +=09int=09bload_leaf_slack;=09/* btree bulk load leaf slack */
> +=09int=09bload_node_slack;=09/* btree bulk load node slack */
>  =09int=09log_recovery_delay;=09/* log recovery delay (secs) */
>  =09int=09mount_delay;=09=09/* mount setup delay (secs) */
>  =09bool=09bug_on_assert;=09=09/* BUG() the kernel on assert failure */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index f1bc88f4367c..673ad21a9585 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -228,6 +228,58 @@ pwork_threads_show(
>  XFS_SYSFS_ATTR_RW(pwork_threads);
>  #endif /* DEBUG */
> =20
> +STATIC ssize_t
> +bload_leaf_slack_store(
> +=09struct kobject=09*kobject,
> +=09const char=09*buf,
> +=09size_t=09=09count)
> +{
> +=09int=09=09ret;
> +=09int=09=09val;
> +
> +=09ret =3D kstrtoint(buf, 0, &val);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09xfs_globals.bload_leaf_slack =3D val;
> +=09return count;
> +}
> +
> +STATIC ssize_t
> +bload_leaf_slack_show(
> +=09struct kobject=09*kobject,
> +=09char=09=09*buf)
> +{
> +=09return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_leaf_slack)=
;
> +}
> +XFS_SYSFS_ATTR_RW(bload_leaf_slack);
> +
> +STATIC ssize_t
> +bload_node_slack_store(
> +=09struct kobject=09*kobject,
> +=09const char=09*buf,
> +=09size_t=09=09count)
> +{
> +=09int=09=09ret;
> +=09int=09=09val;
> +
> +=09ret =3D kstrtoint(buf, 0, &val);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09xfs_globals.bload_node_slack =3D val;
> +=09return count;
> +}
> +
> +STATIC ssize_t
> +bload_node_slack_show(
> +=09struct kobject=09*kobject,
> +=09char=09=09*buf)
> +{
> +=09return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_node_slack)=
;
> +}
> +XFS_SYSFS_ATTR_RW(bload_node_slack);
> +
>  static struct attribute *xfs_dbg_attrs[] =3D {
>  =09ATTR_LIST(bug_on_assert),
>  =09ATTR_LIST(log_recovery_delay),
> @@ -236,6 +288,8 @@ static struct attribute *xfs_dbg_attrs[] =3D {
>  #ifdef DEBUG
>  =09ATTR_LIST(pwork_threads),
>  #endif
> +=09ATTR_LIST(bload_leaf_slack),
> +=09ATTR_LIST(bload_node_slack),
>  =09NULL,
>  };
> =20
>=20

