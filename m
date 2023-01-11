Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84C7C5479D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Jan 2023 04:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbjAKEy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 23:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjAKEyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2023 23:54:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494B82AFA
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 20:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673412849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwDGIIG2kEW7th9yR8DoIeZiikP/oVS4/IYm7KTM+N0=;
        b=brBsQQCOn3YNpLDRSqJ0fzxkPgWTd4vbAn6G6HjRvF4ftTEjYNlIg2wBSn3tcP5h2zfNIk
        jWqFpNqwVQdt3rHPjEQTY6pwwFqd6aMMsecCM9qO+H49BcBd/QzXarky/Q/461Wvi4a92Y
        V+yqgBm2DJ/BldL60Ie7/m7IEX5QWqQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-446-kSPlpkIaMDiUQgd9xHMlFw-1; Tue, 10 Jan 2023 23:54:08 -0500
X-MC-Unique: kSPlpkIaMDiUQgd9xHMlFw-1
Received: by mail-pj1-f69.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so5761402pjp.9
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 20:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AwDGIIG2kEW7th9yR8DoIeZiikP/oVS4/IYm7KTM+N0=;
        b=TqH280NQTZVh5EBdlBPYweyj48aSDDQLnb2KXfzuRBr7OUE7x9vkgqv+UqiBRsxObG
         toHSTmx4OYzWOwrvNLy4bcw4abTyV9miOdf7nOlPxfvQTn7CkJvR1Yhmk80EgCOLfxO6
         9hFSTFeez+HNROx/Gx7yq0dwuXwR/BgSDQQ1aTTZSkIzvpFRJWGwLxqk4SFBiURu+OjQ
         v0+MQAAA4ZmbedIQJGDOvJtJ+tpw8+/BqpvGs8jk/Fo6seQ5MgUENFd6TS2ZpcyTn8uu
         4gMfOnpGBTDHqI3Zzo3gpnvBqQLiXDfgMGnH0JONHP4M/HA32BMd2B+KzTVumNlRkRQs
         T7nA==
X-Gm-Message-State: AFqh2kqwdqWMR5RZ0L80XsmeUZgDXaPYBjupJc+0iiuw8Kapc4n7b2sa
        +MidQ/AWf+BExmCc3vTkrhtyc9Sz4HrZx0e14J1ewcAY4gE/Nzzi94Lyw09fCl2jyJpyz+wjUAw
        TBphG7e8Curg2zImWiJGk
X-Received: by 2002:a17:903:50e:b0:189:bda4:4a39 with SMTP id jn14-20020a170903050e00b00189bda44a39mr68317509plb.49.1673412846854;
        Tue, 10 Jan 2023 20:54:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs+9rrIRD+6pRvHkwnX14gh2BCpLNg+4mxFg/ySKLAFpFMrHGq/R+Lf/NnqdSw7vAx/2ZYhMg==
X-Received: by 2002:a17:903:50e:b0:189:bda4:4a39 with SMTP id jn14-20020a170903050e00b00189bda44a39mr68317481plb.49.1673412846568;
        Tue, 10 Jan 2023 20:54:06 -0800 (PST)
Received: from [10.72.14.8] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902654b00b001895d87225csm8944870pln.182.2023.01.10.20.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 20:54:05 -0800 (PST)
Message-ID: <330d1f1b-02b2-ceb1-5df5-ef6ce0061eb2@redhat.com>
Date:   Wed, 11 Jan 2023 12:53:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] filelock: move file locking definitions to separate
 header file
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Steve French <stfrench@microsoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        devel@lists.orangefs.org, linux-xfs@vger.kernel.org
References: <20230105211937.1572384-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230105211937.1572384-1-jlayton@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 06/01/2023 05:19, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
>
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   arch/arm/kernel/sys_oabi-compat.c |   1 +
>   fs/9p/vfs_file.c                  |   1 +
>   fs/afs/internal.h                 |   1 +
>   fs/attr.c                         |   1 +
>   fs/ceph/locks.c                   |   1 +

ceph part looks good to me.

Thanks

- Xiubo


