Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242E6C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 08:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE985222A2
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 08:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elCyMWPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfKTIRu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 03:17:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbfKTIRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 03:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574237868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byo0YdmPfQszR+pVAeqAo4AdtWqoLV7Y42WMzXdPNQM=;
        b=elCyMWPLXF3u4OqBNl+rQ02Ya1yNoFpCy7knjWItWWzjk23F9D1QkWqTcBbjmRXkbzXMoZ
        XflbsBUvHQSPSTzIvUDG35/+FeHEIkGps6uTve5PZVXm7hlzeJigoHQlRf5gP8Vab7ec6C
        9Ack3rOOpGsw1PdH6OP9lZtuw9ZrAe8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-2_rXSPqvNKKHZoutXKbYiQ-1; Wed, 20 Nov 2019 03:17:44 -0500
Received: by mail-wr1-f70.google.com with SMTP id g17so20712531wru.4
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 00:17:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=yTjlbrTo135ajp3Do02jvImLDQ+o3PHCogbtO+ckgl0=;
        b=RWo03MOGDQzQWRJT7G9MSJPbI5nUUnuErLPBkJ+RlVyd3OMs8bIN4p+P0W9bNw5NQU
         mK33dgLboDKYSgWOBKoITwvxuHIjYwTHE8+ilFxHTR4gpTTkiKPXwrCX0cRNtyswobwC
         si/B/1ZxfJVx84V2ECgxrl4CaAw2RWPYgywRKQw2PiS0ciHUMr8MGyDHbCI3BxL/Ixn9
         jHQ5jrHTvmHe6DKZDVWGULrRumFiQ+MARVBactalPHwq88xFjHLiAExfsAm8mxqK4Z5A
         4oJ0PlLF3+ZjuNeSgAK/b/fuJ7v4ktP2kNBwGjOeltUnmNPCBJULEyT5R8rEFaSq3kDe
         PxdA==
X-Gm-Message-State: APjAAAVdVgo2KMVmqpU0nCXInpkPflbuiSJK0JEyfZJ7HjgSS/bEJW0e
        jZcC3TM6tLom0/gbogKjtqbJpAdvAoYt72JQg75yvpyuMBtiqd5JoUVcRI26SKmtlpS+90ssSpw
        RLYDh43xWEJ3U5WP01lsM
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr1596287wrs.347.1574237863145;
        Wed, 20 Nov 2019 00:17:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqwIBekOyDlZF/r+ZDG7FYrljxYHhxvTJ0Zk+dhGhbn2JSuE1PmD0jjrWjHj/I0KNQ76zVVtoA==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr1596270wrs.347.1574237862864;
        Wed, 20 Nov 2019 00:17:42 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id y19sm6104577wmd.29.2019.11.20.00.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 00:17:41 -0800 (PST)
Date:   Wed, 20 Nov 2019 09:17:39 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Forbid FIEMAP on RT devices
Message-ID: <20191120081739.imddqykmcmmc3erk@orion>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20191119154453.312400-1-cmaiolino@redhat.com>
 <20191119202511.GY4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191119202511.GY4614@dread.disaster.area>
X-MC-Unique: 2_rXSPqvNKKHZoutXKbYiQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 07:25:11AM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2019 at 04:44:53PM +0100, Carlos Maiolino wrote:
> > By now, FIEMAP users have no way to identify which device contains the
> > mapping being reported by the ioctl,
>=20
> This is an incorrect assertion.
>=20
> Users can call FS_IOC_FSGETXATTR and look at the FS_XFLAG_REALTIME
> flag returned to determine what device the XFS data mapping points
> at.

/me didn't know

>=20
> > so, let's forbid FIEMAP on RT
> > devices/files until FIEMAP can properly report the device containing th=
e
> > returned mappings.
>=20
> Also, fiemap on the attribute fork should work regardless of where
> the data for the file is located.
>=20

True.

> So that's two reasons we shouldn't do this :P

Fair enough.

Thanks, I'll try to find another way to deal with that :P

--=20
Carlos

