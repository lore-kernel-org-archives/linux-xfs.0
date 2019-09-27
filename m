Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3F3C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 01:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6060F208C3
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 01:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vPDBlgeK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfI0BnY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 21:43:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33925 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfI0BnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 21:43:24 -0400
Received: by mail-qk1-f193.google.com with SMTP id q203so712141qke.1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2019 18:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zr3/y3LQXh7Xp4kjMWYALipQQ7e+ubjOc3Vo1bKHQzk=;
        b=vPDBlgeK0Wm6DYf1joGlclRD4qkPGXJboAaUuksXYQbf5yzVhLqeXhyITv5et0iTPE
         +5FgqWNOmhn4iveEK5mwWXz2QeLchn+nNgM8DLvKAIXw0S4/hh18GFfLtCChGvGqcodF
         w/+AfMQ5wDWjV6GY7alf+oZIQ4c1JVVm+ClKt/RZyltyZYlZwO56LpokjvtMeRbQk+1J
         pTm+F6qtjrQbUsHH5+FA0/mzsvhrY8XGZdeNMN7F84AwAkJwAajI8OVBvD3i5LC4jOvS
         TlKmcCF4+/wPeZd9N5oNWgjb+jXCyVe3QcxgSzqvbSiS9c+bQvP8KrXHhjTzEwBCg5bw
         4VNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zr3/y3LQXh7Xp4kjMWYALipQQ7e+ubjOc3Vo1bKHQzk=;
        b=oa1e8WVn1+/XLCe90Y0wi/ClOs5hPhBxJDLMIyEtvI0vsIJjPw46+a1C3GwjH9HIdl
         f5gSEv8Oi1lD1gwQ2d3zDnQh+lFd/HW4YxLrxGTHyfQeY9NARJglOC+ahFBStzIUUJP0
         ZeMOXvoLNKTccAxcgjTMySY0UdYPxPBl/xcmbK7xdpoG8CF2FWZ9KSDg9S7c4NouOyKm
         Vk8kZxuxk/kUdSrfZe6VpZvuDnpgAjOENyWCl3z1NEM2uK49VsIEEsGO94D7APOVkdSS
         MNOtVz1FSAMHXjtRSMgHN08FxbwZzO+o4HydauMeUVFneMsKIcH1Dl8WiNl4AuyiqdoX
         Iw1g==
X-Gm-Message-State: APjAAAUuRi/dW/MvPEPN/fBtpAgMiiEXIyq8JfiMBO0Dix90pTihNRin
        Y08a+NfmbW3+sj4UPcTVeKl2qv4FC1gqKW/M5j/NUbwU
X-Google-Smtp-Source: APXvYqxTzaCgl9gCpZsJDV0I/VCakOzUk9uULMQEsnqXhprUFschRxvy1l0XxSzuoI+MWYW89oTJNETau3zc0UOv6T0=
X-Received: by 2002:a37:66c8:: with SMTP id a191mr2256975qkc.108.1569548601684;
 Thu, 26 Sep 2019 18:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAMgD0BoT82ApOQ=Fk6o5KYMsC=z7M88zkNCw9XuMtB0y-xaAmw@mail.gmail.com>
 <20190926123943.vzohbewlaz7dbfnb@pegasus.maiolino.io>
In-Reply-To: <20190926123943.vzohbewlaz7dbfnb@pegasus.maiolino.io>
From:   Jianshen Liu <ljishen@gmail.com>
Date:   Thu, 26 Sep 2019 18:42:43 -0700
Message-ID: <CAMgD0BqXq+zz46MEzZ8=pAAXZo_7s1vcpGQKJyby9EZhYOcVNw@mail.gmail.com>
Subject: Re: Question: Modifying kernel to handle all I/O requests without
 page cache
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Carlos,

Thanks for your reply.

On Thu, Sep 26, 2019 at 5:39 AM Carlos Maiolino <cmaiolino@redhat.com> wrote:
>
> On Wed, Sep 25, 2019 at 03:51:27PM -0700, Jianshen Liu wrote:
> > Hi,
> >
> > I am working on a project trying to evaluate the performance of a
> > workload running on a storage device. I don't want the benchmark
> > result depends on a specific platform (e.g., a platform with X GiB of
> > physical memory).
>
> Well, this does not sound realistic to me. Memory is just only one of the
> variables in how IO throughput will perform. You bypass memory, then, what about
> IO Controller, Disks, Storage cache, etc etc etc? All of these are 'platform
> specific'.

I apologize for any confusion because of my oversimplified project
description. My final goal is to compare the efficiency of different
platforms utilizing a specific storage device to run a given workload.
Since the platforms can be heterogeneous (e.g., x86 vs arm), the
comparison should be based on a reference unit that is relevant to the
capability of the storage device but is irrelevant to a specific
platform. With this reference unit, you can understand how much
performance a platform can give over the capability of the specific
storage device. Once you have this knowledge, you can consider whether
you add/remove some CPUs, memory, the same model of storage devices,
etc can improve the platform efficiency (e.g., cost/reference unit)
with respect to the capability of the storage device under this
workload. Moreover, you can answer questions like can you get the full
unit of performance when you add one more device onto the platform.

My question here is how to evaluate the platform-independent reference
unit for the combination of a given workload and a specific storage
device. Specifically, the reference unit should be a performance value
of the workload under the capability of the storage device. In other
words, this value should not be either enhanced or throttled by the
testing platform. Yes, memory is one of the variables affecting the
I/O performance, the CPU horse, network bandwidth, type of host
interface, version of the software would be the other. But these are
the variables I can easily control. For example, I can check whether
the CPU and/or the network are the performance bottlenecks. The I/O
controller, storage media, and the disk cache are encapsulated in the
storage device, so these are not platform-specific variables as long
as I keep using the same model of the storage device. The use of page
cache, however, may enhance the performance value making the value
become platform-dependent.

> > Because it prevents people from reproducing the same
> > result on a different platform configuration.
>
> Every platform will behave different, memory is only one factor.
>
> > Think about you are
> > benchmarking a read-heavy workload, with data caching enabled you may
> > end up with just testing the performance of the system memory.
> >
>
> Not really true. It all depends on what kind of workload you are talking about.
> And what you are trying to measure.
>
> A read-heavy workload, may well use a lot of page cache, but it all depends on
> the IO patterns, and exactly what statistics you care about. Are you trying to
> measure how well a storage solution will perform on a random workload? On a
> sequential workload?
> Are you trying to measure how well an application will perform? If that's the
> case, removing the page cache from the equation really matters? I.e. will it
> give you realistic results?
>
> If you are benchmarking systems with 'random' kinds of workloads, there are
> several tools around there which can help, and you can configure to use DIO.
>
> > Currently, I'm thinking how to eliminate the cache effects created by
> > the page cache. Direct I/O is a good option for testing with a single
> > application but is not good for testing with unknown
> > applications/workloads.
>
> You can use many tools for that purpose, which can 'emulate' different
> workloads, without needing to modify a specific application.

I don't want to emulate a workload. An emulated workload will most of
the time be different from the source real-world workload. For
example, replaying block I/O recording results generated by fio or
blktrace will probably get different performance numbers from running
the original workload.

> But if you are trying to create benchmarks for a specific application, if your
> benchmarks uses DIO or not, will depend on if the application uses DIO or not.

This is my main question. I want running an application without
involving page caching effects even when the application does not
support DIO.

> > Therefore, it is not feasible to ask people to
> > modify the application source code before running the benchmark.
>
> Well, IMHO, your approach is wrong. First, if you are benchmarking how an application
> will perform, you need to use the same IO patterns the application is using,
> i.e. you won't need to modify it. If it does not use direct IO, benchmarking a system
> using direct IO will bring you something very wrong data. And the opposite is true,
> if the application uses direct IO, you don't want to benchmark a system by using
> the page cache, because one of the things you really want to measure is how well the
> application's cache is performing.
>
> Also, direct IO is also not a good option to use when you 'don't know how to
> issue I/O requests'.
>
> All I/O requests submitted using direct IO must be aligned. So, if the
> application does not issue aligned requests, the IO requests will fail.

Yes, this is one of the difficulties in my problem. The application
may not issue offset, length, buffer addressed aligned I/O. Thus, I
cannot blindly convert application I/O to DIO within the kernel.

> I remember some filesystems to had an option to 'open all files with O_DIRECT by
> default', and many problems being created because IO requests to such files were
> not all sector aligned.
>
> >
> > Making changes within the kernel may only be the option because it is
> > transparent to all user-space applications.
>
> I will hit the same point again :) and my question is: Why? :) Will you be using
> a custom kernel? With this modification? If not, you will not be gathering
> trustable data anyway.

I created a loadable module to patch a vanilla kernel using the kernel
livepatching mechanism.

> > The problem is I don't
> > know how to modify the kernel so that it does not use the page cache
> > for any IOs to a specific storage device. I have tried to append a
> > fadvise64() call with POSIX_FADV_DONTNEED to the end of each
> > read/write system calls. The performance of this approach is far from
> > using Direct I/O. It is also unable to eliminate the caching effects
> > under concurrent I/Os. I'm looking for any advice here to point me an
> > efficient way to remove the cache effects from the page cache.
> >
> > Thanks,
> > Jianshen
>
>
> Benchmarking systems is an 'art', and I am certainly not an expert on it, but at
> first, it looks like you are trying to create a 'generic benchmark' to some
> generic random system. And I will tell you, this is not going to work well. We
> have tons of cases and stories about people running benchmark X on system Z, and
> it performing 'well', but when running their real workload, everything starts to
> perform poorly, exactly because they did not use the correct benchmark at first.

I'm not trying to create a generic benchmark. I just want to create a
benchmark methodology focusing on evaluating the efficiency of a
platform for running a given workload on a specific storage device.

> You have several layers in a storage stack, which starts from how the
> application handles its own IO requests. And each layer which will behave
> differently on each type of workload.

My assumption is that we should run the same workload when comparing
different platforms.

> Apologies to be repeating myself:
>
> If you are trying to measure only a storage solution, there are several tools
> around which can create different kinds of workload.

I would like to know whether there is a tool that can create an
identical workload as the source. But this still does not help to
measure the reference unit that I mentioned.

> If you are trying to measure an application performance on solution X, well,
> it is pointless to measure direct IO if the application does not use it or
> vice-versa, so, modifying an application, again, is not what you will want to do
> for benchmarking, for sure.

The point is that I'm not trying to measure the performance of an
application on solution X. I'm trying to generate a
platform-independent reference unit for the combination of a storage
device and the application.

I have researched different knobs provided by the kernel including
drop_caches, cgroup, and vm subsystem, but none of them can help me to
measure what I want. I would like to know whether there is a variable
in the filesystem that defines the size of the page cache pool. Also,
would it be possible to convert some of the application IOs to DIO
when they are properly aligned? Are there any places in the kernel I
can easily change to bypass the page cache?

Thanks,
Jianshen
