Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3EDC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 14:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A03D120748
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 14:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMptm4di"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfKYOKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 09:10:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43020 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727716AbfKYOKJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Nov 2019 09:10:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574691008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xzTiylz2dIcTnRd+AB+nnDOH/r/+twTJRup0w6i3eA=;
        b=dMptm4di4a1YUQ91VKnGvY1Yrwwkt/FzfvmYmwbwK8XJYIsCRbxFqG/J1ieywVto1cpZ40
        EAaPvN54K0BsOzNKVpC+sljlBlE22bmoMfP2/yloEgy4FC0nobTNDoX3sxTzCjurSJit/+
        AyYWFjYrqtszyPAdJA2TueE8S41yOQA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-i30lLXPxPVewG4vaCnyqEQ-1; Mon, 25 Nov 2019 09:10:06 -0500
Received: by mail-wr1-f70.google.com with SMTP id c16so8914086wro.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2019 06:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=an8vALdIvcFJaWVvDivmn202Q2n39TKo7Ujizgt6p9Q=;
        b=rBeSuc+rrIKOvVnWcapRGN8xsc9R+yDx5hcJJ0pwnBawkYBWTtEs4sCAi36E2ffpuN
         xwafmUH4v/xihpS3Is0p4IQi92H2gD2gZ2AssCUwVC1MpgDbzOb1DJ7gvUbYCI+Y3Yy1
         9gGwGjc8GGL/6TExqM7ejUmgoEtkCToTGd2D9bbU0A0Q9+TnILNjsgwYpLSw8cK637n5
         45O4WtEkIepvh3bbR9poykfDnoDjM8Ta23kH+lsrqg4lK3/XuAJZc/MBT7qbDiYOdIT6
         RmF3+nJ77xYj/KXrhwyPwhg+Jw5TreUdGeg61FklYTi35KdkJzBYNn1TF+tSVLoYjpDs
         0k8A==
X-Gm-Message-State: APjAAAX9CwOoLNfv04Tpg+mzLYGAkRr840Ss4vPez79ewZ44GQhIiqM8
        Hz16d5qUO+pkZHFh6igjkrq2OTS76kJrKJuNyR+yWDtQxOJsuc6pXFor3SWzepyY1fW0TrK1Zle
        3UzHQQNAU1MXNxdj99yFE
X-Received: by 2002:a5d:6944:: with SMTP id r4mr30793201wrw.238.1574691005670;
        Mon, 25 Nov 2019 06:10:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSCng65ENLUtWdQJAr1OpL7fe9YyvBVnxpWKOLBmqt9XJCH49xDvsLCDkKBFZQC8LSaBOdHQ==
X-Received: by 2002:a5d:6944:: with SMTP id r4mr30793176wrw.238.1574691005406;
        Mon, 25 Nov 2019 06:10:05 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a206sm8826744wmf.15.2019.11.25.06.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:10:04 -0800 (PST)
Date:   Mon, 25 Nov 2019 15:10:02 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191125141002.wiowhyetoyin2dwr@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, dchinner@redhat.com
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
 <20191115142055.asqudktld7eblfea@orion>
 <20191115172322.GO6219@magnolia>
 <20191118083008.ttbikkwmrjy4k322@orion>
 <20191121054352.GW6219@magnolia>
 <20191122085033.nluuuvomf64pu3qx@orion>
 <20191122161111.GF6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191122161111.GF6219@magnolia>
X-MC-Unique: i30lLXPxPVewG4vaCnyqEQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 08:11:11AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 22, 2019 at 09:50:33AM +0100, Carlos Maiolino wrote:
> > Hi Darrick.
> >=20
> >=20
> > > > >=20
> > > > > Sure, but I'll believe that when I see it.  And given that Christ=
oph
> > > > > Lameter seems totally opposed to the idea, I think we should keep=
 our
> > > > > silly wrapper for a while to see if they don't accidentally rever=
t it or
> > > > > something.
> > > > >=20
> > > >=20
> > > > Sure, I don't have any plans to do it now in this series or in a ve=
ry near
> > > > future, I just used the email to share the idea :P
> > >=20
> > > Eh, well, FWIW I took a second look at all the kvfree/kfree and decid=
ed
> > > that the usage was correct.  For future reference, please do the
> > > straight change as one patch and straighten out the usages as a separ=
ate
> > > patch.
> > >=20
> >=20
> > I'm not sure what you meant by 'straight change' and 'straighten out'.
> >=20
> > Do you mean to do send a single patch with only the changes made by the
> > 'find&replace' command, followed up by a kfree() -> kvfree() where appr=
opriate?
>=20
> Er, the opposite in this case -- Patch 1 replaces all the kmem_free
> calls with kvfree calls (because that's what kmem_free did).  Patch 2
> then changes the kvfree calls to kfree calls, but only for the cases
> where we kmalloc'd the memory.

Makes perfect sense. Thanks, I'll ensure to do that next time.

>=20
> --D
>=20
> > Cheers.
> >=20
> > > In any case it seemed to test ok over the weekend (and still seems ok
> > > with your series from today), so...
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >=20
> >=20
> > > --D
> > >=20
> > > > Thanks for the review.
> > > >=20
> > > > --=20
> > > > Carlos
> > > >=20
> > >=20
> >=20
> > --=20
> > Carlos
> >=20
>=20

--=20
Carlos

