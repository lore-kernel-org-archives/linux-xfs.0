Return-Path: <SRS0=aEZv=Z7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7015EC43603
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Dec 2019 15:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E34A2077B
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Dec 2019 15:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fis3MXlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfLIPOs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:14:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34415 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726197AbfLIPOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Dec 2019 10:14:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575904487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apEbWuHWMvU1XyriWgvbkud5MG7uv5HtzR2HpoHo9sM=;
        b=fis3MXlkPF40/ALctPH2I1IepiEXtYDByR8/xWu6K5k+KtSAdhfW9sd5UIi8/s7morapS6
        v2i7z4CJAE0lxIh1oH6HhYFB+URkqpmjoLHXnWx9EAwxrpmumWIotywa6eIJ5osNCD3a2o
        f9r1j80RtwJqd8oQThS5Tg4F1GkbNq8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-WAm6t6R4PZyHJq9tEoTchQ-1; Mon, 09 Dec 2019 10:14:46 -0500
Received: by mail-wm1-f69.google.com with SMTP id l13so3959541wmj.8
        for <linux-xfs@vger.kernel.org>; Mon, 09 Dec 2019 07:14:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LMFY5bivJAp/+tUTi1B+IWd4uWb96KSd18hRiTJ7v94=;
        b=ecS2PjJsnfqkzZdr5wt4sqK1kefw1uiOTKEla60UPYYb0WXcFxmna+6q8uFfdxigCA
         PFpK0zGMOXWqNk24C1sxXiSkq+QbARGxJG67bFvJc9dBZRmoDsarwQS/z1br12XWKeV7
         bSJ9qyN+2uw2tLWw9EcKKqZoR7tVEt5AhiPHySfPSDmV7pBOqHjxw7pTUThn1d75QGcg
         x+xCYb9kIjMbD7MklJ7dSFO4RlEdm/nO3LhHLgF5lYdNBIhvokaX6ERwQNEy8sO2ET3e
         6hm2e3p1c7ra/rO9KgcaipmCz349/KV1ZvDS+XnEs7XE0IsF1wpgNrRq+L41RATswt8B
         fk3Q==
X-Gm-Message-State: APjAAAU35jiAvStxnkvG3zvAn20cMh9EcH7hEEJdsnqC5gBQkSVfxcNt
        XtI+mjZ4ynhiGSdEEpz6YgOGz0TgiWBeJEhpm4dDBuACqVmqcr2meC5zwf9l87wPb/2nsgc2hJO
        UubdmL6yTWlofvXKgR8tU
X-Received: by 2002:adf:b605:: with SMTP id f5mr2630781wre.383.1575904485132;
        Mon, 09 Dec 2019 07:14:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBMhSMeAPFOboOovU2F6btz7m5cm25/pHcAmtcknViU3wqY+7q3kyinuk0Utb7rjvBsYyZXQ==
X-Received: by 2002:adf:b605:: with SMTP id f5mr2630752wre.383.1575904484897;
        Mon, 09 Dec 2019 07:14:44 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id z13sm77859wmi.18.2019.12.09.07.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 07:14:44 -0800 (PST)
Date:   Mon, 9 Dec 2019 16:14:42 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_admin: support external log devices
Message-ID: <20191209151442.jhfu62sl3zypmtb6@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <157534126287.396264.13869948892885966217.stgit@magnolia>
 <157534126919.396264.193318734395972520.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157534126919.396264.193318734395972520.stgit@magnolia>
X-MC-Unique: WAm6t6R4PZyHJq9tEoTchQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 06:47:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add to xfs_admin the ability to pass external log devices to xfs_db.
> This is necessary to make changes on such filesystems.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  db/xfs_admin.sh      |   12 ++++++++++--
>  man/man8/xfs_admin.8 |   14 ++++++++++++++
>  2 files changed, 24 insertions(+), 2 deletions(-)
>=20
>=20
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 305ef2b7..bd325da2 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -7,7 +7,7 @@
>  status=3D0
>  DB_OPTS=3D""
>  REPAIR_OPTS=3D""
> -USAGE=3D"Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] devic=
e"
> +USAGE=3D"Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] devic=
e [logdev]"
> =20
>  while getopts "efjlpuc:L:U:V" c
>  do
> @@ -33,7 +33,15 @@ done
>  set -- extra $@
>  shift $OPTIND
>  case $# in
> -=091)=09if [ -n "$DB_OPTS" ]
> +=091|2)
> +=09=09# Pick up the log device, if present
> +=09=09if [ -n "$2" ]; then
> +=09=09=09DB_OPTS=3D$DB_OPTS" -l '$2'"
> +=09=09=09test -n "$REPAIR_OPTS" && \
> +=09=09=09=09REPAIR_OPTS=3D$REPAIR_OPTS" -l '$2'"
> +=09=09fi
> +
> +=09=09if [ -n "$DB_OPTS" ]
>  =09=09then
>  =09=09=09eval xfs_db -x -p xfs_admin $DB_OPTS $1
>  =09=09=09status=3D$?
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index 20a114f5..8afc873f 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -15,6 +15,9 @@ xfs_admin \- change parameters of an XFS filesystem
>  .I uuid
>  ]
>  .I device
> +[
> +.I logdev
> +]
>  .br
>  .B xfs_admin \-V
>  .SH DESCRIPTION
> @@ -31,6 +34,17 @@ A number of parameters of a mounted filesystem can be =
examined
>  and modified using the
>  .BR xfs_growfs (8)
>  command.
> +.PP
> +The optional
> +.B logdev
> +parameter specifies the device special file where the filesystem's exter=
nal
> +log resides.
> +This is required only for filesystems that use an external log.
> +See the
> +.B mkfs.xfs \-l
> +option, and refer to
> +.BR xfs (5)
> +for a detailed description of the XFS log.
>  .SH OPTIONS
>  .TP
>  .B \-e
>=20

--=20
Carlos

