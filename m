Return-Path: <SRS0=aEZv=Z7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C61C43603
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Dec 2019 15:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCCE207FD
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Dec 2019 15:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nr7Ib79r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfLIPm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:42:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfLIPm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Dec 2019 10:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575906146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fp3Hw5Ked+ON3iNV8Nhbm+ixAvyxfY2nYWopXDtyJ8g=;
        b=Nr7Ib79reE9mYR6hfG8BmQYxbyO3CI2Oj+w6hm4p0Y25QXAn9thFmVFrdbSDNonI1MB6VV
        KpV1PpuGETebJAQV/mBx0/74OhciDecCzOsYx6/cLK53GhZVWGh4m0KLw/6suh7q0ttQrz
        nUhqRzeA8RkCGzyAuD84dpkueR0l0U0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-N5oKgBjDPJCtTJbjGuzwKg-1; Mon, 09 Dec 2019 10:42:25 -0500
Received: by mail-wr1-f71.google.com with SMTP id i9so7662188wru.1
        for <linux-xfs@vger.kernel.org>; Mon, 09 Dec 2019 07:42:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=4mxC2I4l/juH6sVLmtI8MvzJYLESTgYRkn4i0vqc36s=;
        b=LMv0J94Q5SkY+oZnFZYSx4hh6nGJPaAi2i9BV1bJx8+ycWAj5/vFKmrauQQoYkutpH
         1RtJ8cBh2LDSesD5o9ScMI9D9GKH/f2+eGk3zeMD9qXyGm6Hy+48A0wpRh/Qjlt0JL1N
         43ArdCgULJReuldgyVspibFBZVcl7K2YFKPv+t5I+sYOTTT/Q7+awQonvewxbqgt75re
         A6nXQTqBsgFVv0BXNZa+nwnNtfwoYDjmFXM/8Afp1GpYhFcixLYInpjxoq0ZzyLqQeg+
         ihPnoDS3PyYRBMRE1Pd5kvJbtfcc0i5XMgQK7ofqIWyZGt+FOiQNGjLix5S4TWAXSnVD
         iWRQ==
X-Gm-Message-State: APjAAAVXxRxL9sQ8G2ix+W5ZUa5cj0YUirsror19Rifv7buJdruy89iR
        EjPtB2eqqMYgjg/QIWj7sj5Qa42/RhsofMOZCTluFGZEF4nnvIc952ypVl3Er4XjyokDgoAlKHw
        AIPG1n7qbuXKIvnjuaKAr
X-Received: by 2002:a05:600c:10cd:: with SMTP id l13mr26854313wmd.102.1575906144013;
        Mon, 09 Dec 2019 07:42:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNEWpnYbYDRJuGZHHT+4hp47t5XbObHvw2J0UdMDZsKXmjk4awDHu7i8dMsS0RJ/XIULAlSw==
X-Received: by 2002:a05:600c:10cd:: with SMTP id l13mr26854292wmd.102.1575906143759;
        Mon, 09 Dec 2019 07:42:23 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a127sm123217wmh.43.2019.12.09.07.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 07:42:23 -0800 (PST)
Date:   Mon, 9 Dec 2019 16:42:20 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_admin: enable online label getting and setting
Message-ID: <20191209154220.mhr7vx43gezdz4nt@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <157534126287.396264.13869948892885966217.stgit@magnolia>
 <157534127538.396264.18160137569276022475.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157534127538.396264.18160137569276022475.stgit@magnolia>
X-MC-Unique: N5oKgBjDPJCtTJbjGuzwKg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 06:47:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Connect xfs_admin -L to the xfs_io label command so that we can get and
> set the label for a live filesystem.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/xfs_admin.sh      |   42 ++++++++++++++++++++++++++++++++++++++++--
>  man/man8/xfs_admin.8 |    4 +++-
>  2 files changed, 43 insertions(+), 3 deletions(-)
>=20

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>=20
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index bd325da2..d18959bf 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -7,8 +7,30 @@
>  status=3D0
>  DB_OPTS=3D""
>  REPAIR_OPTS=3D""
> +IO_OPTS=3D""
>  USAGE=3D"Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] devic=
e [logdev]"
> =20
> +# Try to find a loop device associated with a file.  We only want to ret=
urn
> +# one loopdev (multiple loop devices can attach to a single file) so we =
grab
> +# the last line and return it if it's actually a block device.
> +try_find_loop_dev_for_file() {
> +=09local x=3D"$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
> +=09test -b "$x" && echo "$x"
> +}
> +
> +# See if we can find a mount point for the argument.
> +find_mntpt_for_arg() {
> +=09local arg=3D"$1"
> +
> +=09# See if we can map the arg to a loop device
> +=09local loopdev=3D"$(try_find_loop_dev_for_file "${arg}")"
> +=09test -n "$loopdev" && arg=3D"$loopdev"
> +
> +=09# If we find a mountpoint for the device, do a live query;
> +=09# otherwise try reading the fs with xfs_db.
> +=09findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null
> +}
> +
>  while getopts "efjlpuc:L:U:V" c
>  do
>  =09case $c in
> @@ -16,8 +38,16 @@ do
>  =09e)=09DB_OPTS=3D$DB_OPTS" -c 'version extflg'";;
>  =09f)=09DB_OPTS=3D$DB_OPTS" -f";;
>  =09j)=09DB_OPTS=3D$DB_OPTS" -c 'version log2'";;
> -=09l)=09DB_OPTS=3D$DB_OPTS" -r -c label";;
> -=09L)=09DB_OPTS=3D$DB_OPTS" -c 'label "$OPTARG"'";;
> +=09l)=09DB_OPTS=3D$DB_OPTS" -r -c label"
> +=09=09IO_OPTS=3D$IO_OPTS" -r -c label"
> +=09=09;;
> +=09L)=09DB_OPTS=3D$DB_OPTS" -c 'label "$OPTARG"'"
> +=09=09if [ "$OPTARG" =3D "--" ]; then
> +=09=09=09IO_OPTS=3D$IO_OPTS" -c 'label -c'"
> +=09=09else
> +=09=09=09IO_OPTS=3D$IO_OPTS" -c 'label -s "$OPTARG"'"
> +=09=09fi
> +=09=09;;
>  =09p)=09DB_OPTS=3D$DB_OPTS" -c 'version projid32bit'";;
>  =09u)=09DB_OPTS=3D$DB_OPTS" -r -c uuid";;
>  =09U)=09DB_OPTS=3D$DB_OPTS" -c 'uuid "$OPTARG"'";;
> @@ -41,6 +71,14 @@ case $# in
>  =09=09=09=09REPAIR_OPTS=3D$REPAIR_OPTS" -l '$2'"
>  =09=09fi
> =20
> +=09=09# Try making the changes online, if supported
> +=09=09if [ -n "$IO_OPTS" ] && mntpt=3D"$(find_mntpt_for_arg "$1")"
> +=09=09then
> +=09=09=09eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
> +=09=09=09test "$?" -eq 0 && exit 0
> +=09=09fi
> +
> +=09=09# Otherwise try offline changing
>  =09=09if [ -n "$DB_OPTS" ]
>  =09=09then
>  =09=09=09eval xfs_db -x -p xfs_admin $DB_OPTS $1
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index 8afc873f..220dd803 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -26,7 +26,7 @@ uses the
>  .BR xfs_db (8)
>  command to modify various parameters of a filesystem.
>  .PP
> -Devices that are mounted cannot be modified.
> +Devices that are mounted cannot be modified, except as noted below.
>  Administrators must unmount filesystems before
>  .BR xfs_admin " or " xfs_db (8)
>  can convert parameters.
> @@ -67,6 +67,7 @@ log buffers).
>  .TP
>  .B \-l
>  Print the current filesystem label.
> +This command can be run if the filesystem is mounted.
>  .TP
>  .B \-p
>  Enable 32bit project identifier support (PROJID32BIT feature).
> @@ -102,6 +103,7 @@ The filesystem label can be cleared using the special=
 "\c
>  .B \-\-\c
>  " value for
>  .IR label .
> +This command can be run if the filesystem is mounted.
>  .TP
>  .BI \-U " uuid"
>  Set the UUID of the filesystem to
>=20

--=20
Carlos

