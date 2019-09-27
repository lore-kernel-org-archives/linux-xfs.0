Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A58EC4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 10:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2869120673
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 10:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdN9v1C7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfI0Kj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 06:39:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725890AbfI0Kj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Sep 2019 06:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569580797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7LnqmfKc2kh1AtEA4sE9Fgs9CRUUq8LZpKrc3pfrfg=;
        b=cdN9v1C7OTCYpGxzX5J6wqXd0WRJSOlRl1Txe/fOirDNrIm1Ek/xcRW0rVR2v9a5luVlSw
        s38P8NIPr/k8ndbPG/5UxkEJFhGNdYKSE8BPNWa5xqQGHnJxGqv86n706yMpmCPeghjuVc
        cpzI16TyXTuS6SBQTwO4cMdDKP0DKf4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-KEWq3FAVPxCJYfNxyseG_g-1; Fri, 27 Sep 2019 06:39:54 -0400
Received: by mail-wm1-f71.google.com with SMTP id r21so2051726wme.5
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 03:39:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=W6nJOPLzmgwnJA6k+pNMZ84niLeweFc5kz/zDL7rFfE=;
        b=kiQGzChDKZnaff/m7ZVJVE6Mn7maQu4l4KDKGL52j340bXqHdWQupV4jtQ3nlhqtBu
         VBHPq3tv9dJz5XIhv/LFg3a2dW8kW6ePGIuRrM3cPRNAtrI4sZygVKWfzgQoAE57w/1g
         SN2pLijwkFwWlrskw/GeiWcDWaV14lB6IciE5qCwzDZPy4vUpzgZK7P4jK7LrXNM3g+R
         Y2xVDFur2uvArWXkz7nKeBQh7fl6izltBUD5PDfEKkjSPr/Tvh34t7W+H7gRu07r39EW
         YA1CXfAmY+lfCMzSoz5jHFfQoVbKITaSomAr1hn4244ekd6/VALWTfTYlBE85kAGBTPu
         gj1Q==
X-Gm-Message-State: APjAAAV/wCmIJ1EkHt4QHUti5BGGPuf4px/YC0wOGAHwzO27vOD+b5q6
        /T/5L84Rinwu1Gdz32+vGEWSPymVCldw5Up0Tlf7DtB8ZRDioaae7dv1BnjR+VDbaNVAl5mhgoR
        +2bULmZyau4kW72gRmH2R
X-Received: by 2002:a1c:3b06:: with SMTP id i6mr6587070wma.6.1569580793087;
        Fri, 27 Sep 2019 03:39:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzhPAa1sunpiyAXE/evWrFBThmMHa6NRuaAF8yKF/dnvRG0/kkzUpUHl2+YtlV+gi3Ti9iFzQ==
X-Received: by 2002:a1c:3b06:: with SMTP id i6mr6587047wma.6.1569580792758;
        Fri, 27 Sep 2019 03:39:52 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id 3sm6896267wmo.22.2019.09.27.03.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 03:39:52 -0700 (PDT)
Date:   Fri, 27 Sep 2019 12:39:50 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Jianshen Liu <ljishen@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question: Modifying kernel to handle all I/O requests without
 page cache
Message-ID: <20190927103949.57c44crqjx3p2h3w@pegasus.maiolino.io>
Mail-Followup-To: Jianshen Liu <ljishen@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CAMgD0BoT82ApOQ=Fk6o5KYMsC=z7M88zkNCw9XuMtB0y-xaAmw@mail.gmail.com>
 <20190926123943.vzohbewlaz7dbfnb@pegasus.maiolino.io>
 <CAMgD0BqXq+zz46MEzZ8=pAAXZo_7s1vcpGQKJyby9EZhYOcVNw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMgD0BqXq+zz46MEzZ8=pAAXZo_7s1vcpGQKJyby9EZhYOcVNw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-MC-Unique: KEWq3FAVPxCJYfNxyseG_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

I'm gonna move this question to the top, for a short answer:

> > But if you are trying to create benchmarks for a specific application, =
if your
> > benchmarks uses DIO or not, will depend on if the application uses DIO =
or not.
>=20
> This is my main question. I want running an application without
> involving page caching effects even when the application does not
> support DIO.


You simply can't. Aligned IOs is a primitive of block devices (if I can use
these words). If you don't submit aligned IOs, you can't access block devic=
es
directly.

You can't modify the kernel to do that either, because that's exactly one o=
f the
goals of the buffer cache, other than improving performance of course. If y=
ou
submit an unaligned IO, kernel will first read in the whole sectors from th=
e
block device, modify them accordingly to your unaligned IO and write the wh=
ole
sectors back.

For reads, the process is the same, kernel will read at least the whole sec=
tor,
never just a part of it.


Now, let me try a longer reply :P


>=20
On Thu, Sep 26, 2019 at 06:42:43PM -0700, Jianshen Liu wrote:
> Hi Carlos,
>=20
> Thanks for your reply.
>=20
> On Thu, Sep 26, 2019 at 5:39 AM Carlos Maiolino <cmaiolino@redhat.com> wr=
ote:
> >
> > On Wed, Sep 25, 2019 at 03:51:27PM -0700, Jianshen Liu wrote:
> > > Hi,
> > >
> > > I am working on a project trying to evaluate the performance of a
> > > workload running on a storage device. I don't want the benchmark
> > > result depends on a specific platform (e.g., a platform with X GiB of
> > > physical memory).
> >
> > Well, this does not sound realistic to me. Memory is just only one of t=
he
> > variables in how IO throughput will perform. You bypass memory, then, w=
hat about
> > IO Controller, Disks, Storage cache, etc etc etc? All of these are 'pla=
tform
> > specific'.
>=20
> I apologize for any confusion because of my oversimplified project
> description. My final goal is to compare the efficiency of different
> platforms utilizing a specific storage device to run a given workload.
> Since the platforms can be heterogeneous (e.g., x86 vs arm), the
> comparison should be based on a reference unit that is relevant to the
> capability of the storage device but is irrelevant to a specific
> platform.

The storage vendors usually already provide you with the hardware limitatio=
ns
which you can use as the reference units you are looking for. Like maximum =
IOPS
and Throughput such storage solution can support. These are all platform an=
d
application independent reference units you can use.

> With this reference unit, you can understand how much
> performance a platform can give over the capability of the specific
> storage device.

Again, you can use the numbers provided by the vendor. For example, XFS is
designed to be a high-throughput filesystem, and the goal is to be as close=
 as
possible to the hardware limits, but of course, it all depends on everythin=
g
else.


> Once you have this knowledge, you can consider whether
> you add/remove some CPUs, memory, the same model of storage devices,
> etc can improve the platform efficiency (e.g., cost/reference unit)
> with respect to the capability of the storage device under this
> workload.

Storage hardware limitations, vendor provided numbers also applies here. An=
d you
can't simply discard application's behavior here. Everything you mentioned =
here
will be directly affected by the application you're using, so, modifying th=
e
application will give you nothing useful to work on.

> Moreover, you can answer questions like can you get the full
> unit of performance when you add one more device onto the platform.

For "Full unit of performance", you can again, use vendor-provided numbers =
:)

> My question here is how to evaluate the platform-independent reference
> unit for the combination of a given workload and a specific storage
> device.

Use the application you are trying to evaluate, in different platforms, and
measure it.


> Specifically, the reference unit should be a performance value
> of the workload under the capability of the storage device. In other
> words, this value should not be either enhanced or throttled by the
> testing platform. Yes, memory is one of the variables affecting the
> I/O performance, the CPU horse, network bandwidth, type of host
> interface, version of the software would be the other. But these are
> the variables I can easily control. For example, I can check whether
> the CPU and/or the network are the performance bottlenecks. The I/O
> controller, storage media, and the disk cache are encapsulated in the
> storage device, so these are not platform-specific variables as long
> as I keep using the same model of the storage device. The use of page
> cache, however, may enhance the performance value making the value
> become platform-dependent.

Again, everything you measure, will have no meaning if you don't use realis=
tic
data. You can't simply bypass the buffer cache if the application does not
support it, and so, it is pointless to measure how an application will 'per=
form'
in such scenario.

> I don't want to emulate a workload. An emulated workload will most of
> the time be different from the source real-world workload. For
> example, replaying block I/O recording results generated by fio or
> blktrace will probably get different performance numbers from running
> the original workload.

And I think this is the crux for your issue.

You don't want an emulated workload, because it may not reproduce the real-=
world
workload.

Why then are you trying to find a way to bypass the page/buffer cache, on a=
n
application that will not support direct IO and won't be able to use it lik=
e
that?

You don't want to collect data using emulated workloads, but at the same ti=
me
you want to use something that is simply totally out of the reality? Does n=
ot
make any sense to me.

fio can get different performance numbers? Sure, I agree, no performance
measurement tool can beat the real workload of a specific application, but,=
 what
you are trying to do doesn't either, so, what's the difference?


> > Benchmarking systems is an 'art', and I am certainly not an expert on i=
t, but at
> > first, it looks like you are trying to create a 'generic benchmark' to =
some
> > generic random system. And I will tell you, this is not going to work w=
ell. We
> > have tons of cases and stories about people running benchmark X on syst=
em Z, and
> > it performing 'well', but when running their real workload, everything =
starts to
> > perform poorly, exactly because they did not use the correct benchmark =
at first.
>=20
> I'm not trying to create a generic benchmark. I just want to create a
> benchmark methodology focusing on evaluating the efficiency of a
> platform for running a given workload on a specific storage device.

Ok, so, you want to evaluate how platform X will behave with your applicati=
on +
storage.

Why then you want to modify that original platform behavior? In this case, =
let's
say, by bypassing Linux page/buffer cache.

By platform you mean hardware? Well, then, use the same software stack.

>=20
> > You have several layers in a storage stack, which starts from how the
> > application handles its own IO requests. And each layer which will beha=
ve
> > differently on each type of workload.
>=20
> My assumption is that we should run the same workload when comparing
> different platforms.

Yes, and if you don't want to use emulated workloads, you should don't try =
to
hack your software stack to behave in weird ways.

If you want to compare platforms, ensure to use the same software stack.
Including the same configuration. That's all.

> > If you are trying to measure an application performance on solution X, =
well,
> > it is pointless to measure direct IO if the application does not use it=
 or
> > vice-versa, so, modifying an application, again, is not what you will w=
ant to do
> > for benchmarking, for sure.
>=20
> The point is that I'm not trying to measure the performance of an
> application on solution X. I'm trying to generate a
> platform-independent reference unit for the combination of a storage
> device and the application.

You simply can't. Get any enterprise application out there, you will see th=
e
application vendors usually certify certain combinations of hardware + soft=
ware
stack.

There is a reason for that. There are many variables in the way, not only t=
he
page/buffer cache. You can't simply bypass the page/buffer cache, and think
you'll get some realistic base reference unit you can work with. Specially =
if
you are not sure how the application behaves.

If you want to have base reference unit numbers for a storage solution, use=
 the
vendor's reference numbers. They are platform agnostic. Everything else abo=
ve
that will be totally interdependent.

> I have researched different knobs provided by the kernel including
> drop_caches, cgroup, and vm subsystem, but none of them can help me to
> measure what I want.

Because I honestly think what you are trying to measure is unrealistic :)

> I would like to know whether there is a variable
> in the filesystem that defines the size of the page cache pool.

There is no such silver bullet :)

> Also,
> would it be possible to convert some of the application IOs to DIO
> when they are properly aligned?

Not that I know about, but well, I'm not really an expert in the DIO code, =
maybe
there's a way to fall back to buffered io, although, I don't think so.

> Are there any places in the kernel I
> can easily change to bypass the page cache?

No.


--=20
Carlos

