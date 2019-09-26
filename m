Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E8EC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 12:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37BA1217F4
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 12:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvMZ+9rd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfIZMjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 08:39:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21223 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726351AbfIZMjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 08:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569501590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1R52mjpJH2aH44NNrCF9yQti9LtZhobAzoR3I2PL9NA=;
        b=HvMZ+9rd57h2cxPtEae9S18mzGFnu+wjFEpgjmiPPS8FIJiTy6YOapHBOs17sxK0msxEro
        2Fe9WyxWeuwlrlxXZkR2Al6vSFhPo7CRXdVNSD3c623RJjdx+neXMWNO3/+fnuSCOsXeWH
        ImuJLbfSFPYDTtyt64VAnBQTEIfpl78=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-GfxLZIr2NJCvRKcKhYeSOw-1; Thu, 26 Sep 2019 08:39:48 -0400
Received: by mail-wr1-f72.google.com with SMTP id z1so878607wrw.21
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2019 05:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=JOHmIwETt7NtTyL/ExumoyiOmQEobQUAAiNqx5AgCYw=;
        b=cKaGJqDAOzAcF5a8Xs5MLLeHP/i1gmCu+3zztLmcKXzqyQeORtbVS/ARwOjcdeSbuj
         axxz8exnT5ENBy4yOEdm9qVGa7N7F9BCawLncl7d0nQ2W5ifijt3yaHTc9VBOroYHQCS
         sKUCDiest4tZgPxnaC1MPS0dXScWnDOfFIqYSoNh7oa7ueQfLqNHm81a9C/olgrzM+bG
         sPeq6hbsPQKQRq5X2KL/wH/Xzw0ybiSIdvaMVO6m4nTwWsVNwkR1pEBZoCG6tJXpNb8S
         2xGXkaeuj7RVxvJ6QliBamIGOB7HrSRDQtjuWlNrlGJQvI5qsa71blJQnr0fXpx+r8R/
         5PHA==
X-Gm-Message-State: APjAAAXE3bO9PXtKoKCaI2ibACCc8bZo7t9J/yz7SGGqHPK3dQfTn1M4
        KEL0J73tLm6MVWd0QQmZoyLGakKHuzclPaf6feDIFld1h95h+dQ1SYmltMVsf5f/y2SU4MRy5F5
        fgdzVWmoErAqyAD41snaX
X-Received: by 2002:adf:e50e:: with SMTP id j14mr2912762wrm.178.1569501587567;
        Thu, 26 Sep 2019 05:39:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/8Kqlhdr54SUd6uPkiR4+5lq1Jo/3Mv+F81pL7jBxdghb4UQD9+7P+Y1AZ1qRobaULhTCNQ==
X-Received: by 2002:adf:e50e:: with SMTP id j14mr2912751wrm.178.1569501587294;
        Thu, 26 Sep 2019 05:39:47 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id e9sm13322986wme.3.2019.09.26.05.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 05:39:46 -0700 (PDT)
Date:   Thu, 26 Sep 2019 14:39:45 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Jianshen Liu <ljishen@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question: Modifying kernel to handle all I/O requests without
 page cache
Message-ID: <20190926123943.vzohbewlaz7dbfnb@pegasus.maiolino.io>
Mail-Followup-To: Jianshen Liu <ljishen@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CAMgD0BoT82ApOQ=Fk6o5KYMsC=z7M88zkNCw9XuMtB0y-xaAmw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMgD0BoT82ApOQ=Fk6o5KYMsC=z7M88zkNCw9XuMtB0y-xaAmw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-MC-Unique: GfxLZIr2NJCvRKcKhYeSOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.


I am removing linux-fsdevel from the CC, because it's not really the quorum=
 for
it.

On Wed, Sep 25, 2019 at 03:51:27PM -0700, Jianshen Liu wrote:
> Hi,
>=20
> I am working on a project trying to evaluate the performance of a
> workload running on a storage device. I don't want the benchmark
> result depends on a specific platform (e.g., a platform with X GiB of
> physical memory).

Well, this does not sound realistic to me. Memory is just only one of the
variables in how IO throughput will perform. You bypass memory, then, what =
about
IO Controller, Disks, Storage cache, etc etc etc? All of these are 'platfor=
m
specific'.

> Because it prevents people from reproducing the same
> result on a different platform configuration.

Every platform will behave different, memory is only one factor.

> Think about you are
> benchmarking a read-heavy workload, with data caching enabled you may
> end up with just testing the performance of the system memory.
>

Not really true. It all depends on what kind of workload you are talking ab=
out.
And what you are trying to measure.

A read-heavy workload, may well use a lot of page cache, but it all depends=
 on
the IO patterns, and exactly what statistics you care about. Are you trying=
 to
measure how well a storage solution will perform on a random workload? On a
sequential workload?
Are you trying to measure how well an application will perform? If that's t=
he
case, removing the page cache from the equation really matters? I.e. will i=
t
give you realistic results?

If you are benchmarking systems with 'random' kinds of workloads, there are
several tools around there which can help, and you can configure to use DIO=
.

> Currently, I'm thinking how to eliminate the cache effects created by
> the page cache. Direct I/O is a good option for testing with a single
> application but is not good for testing with unknown
> applications/workloads.

You can use many tools for that purpose, which can 'emulate' different
workloads, without needing to modify a specific application.

But if you are trying to create benchmarks for a specific application, if y=
our
benchmarks uses DIO or not, will depend on if the application uses DIO or n=
ot.

> Therefore, it is not feasible to ask people to
> modify the application source code before running the benchmark.

Well, IMHO, your approach is wrong. First, if you are benchmarking how an a=
pplication
will perform, you need to use the same IO patterns the application is using=
,
i.e. you won't need to modify it. If it does not use direct IO, benchmarkin=
g a system
using direct IO will bring you something very wrong data. And the opposite =
is true,
if the application uses direct IO, you don't want to benchmark a system by =
using
the page cache, because one of the things you really want to measure is how=
 well the
application's cache is performing.

Also, direct IO is also not a good option to use when you 'don't know how t=
o
issue I/O requests'.

All I/O requests submitted using direct IO must be aligned. So, if the
application does not issue aligned requests, the IO requests will fail.

I remember some filesystems to had an option to 'open all files with O_DIRE=
CT by
default', and many problems being created because IO requests to such files=
 were
not all sector aligned.

>=20
> Making changes within the kernel may only be the option because it is
> transparent to all user-space applications.

I will hit the same point again :) and my question is: Why? :) Will you be =
using
a custom kernel? With this modification? If not, you will not be gathering
trustable data anyway.

> The problem is I don't
> know how to modify the kernel so that it does not use the page cache
> for any IOs to a specific storage device. I have tried to append a
> fadvise64() call with POSIX_FADV_DONTNEED to the end of each
> read/write system calls. The performance of this approach is far from
> using Direct I/O. It is also unable to eliminate the caching effects
> under concurrent I/Os. I'm looking for any advice here to point me an
> efficient way to remove the cache effects from the page cache.
>=20
> Thanks,
> Jianshen


Benchmarking systems is an 'art', and I am certainly not an expert on it, b=
ut at
first, it looks like you are trying to create a 'generic benchmark' to some
generic random system. And I will tell you, this is not going to work well.=
 We
have tons of cases and stories about people running benchmark X on system Z=
, and
it performing 'well', but when running their real workload, everything star=
ts to
perform poorly, exactly because they did not use the correct benchmark at f=
irst.


You have several layers in a storage stack, which starts from how the
application handles its own IO requests. And each layer which will behave
differently on each type of workload.

Apologies to be repeating myself:

If you are trying to measure only a storage solution, there are several too=
ls
around which can create different kinds of workload.

If you are trying to measure an application performance on solution X, well=
,
it is pointless to measure direct IO if the application does not use it or
vice-versa, so, modifying an application, again, is not what you will want =
to do
for benchmarking, for sure.

Hope to have helped (and not created more questions :)

Cheers

--=20
Carlos

