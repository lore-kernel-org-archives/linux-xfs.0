Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38327 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754866AbdCGRVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 12:21:12 -0500
Received: by mail-it0-f45.google.com with SMTP id m27so9400361iti.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2017 09:19:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170306215112.GN17542@dastard>
References: <CACj3i72avXdkrQdfGnfeRpnOoPo+bcBMForczMt_dnK-ZXQbkg@mail.gmail.com>
 <20170306215112.GN17542@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 7 Mar 2017 09:04:15 +0100
Message-ID: <CACj3i73jas7WfpPwxfRx8E47okzmQpZfToMjyAu5uie2pAWEtA@mail.gmail.com>
Subject: Re: xfstests and (automated) workflow?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 6, 2017 at 10:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 06, 2017 at 03:25:03PM +0100, Jan Tulak wrote:
>> Hi guys,
>>
>> II decided to streamline and automate some things for me with testing
>> xfs, but as I worked on it, I realise that surely I'm not the first
>> one to do that. So I would like to ask you, can you share your tips
>> and tricks? :-)
>>
>> What I began to work at is a small suite of scripts to deploy a docker
>> container (could be changed for a VM) which compiles my local version
>> of xfsprogs and xfstests, runs it, and if I specify multiple
>> revisions, it does it for every of the revisions and then tells me
>> which test results changed between the revisions. I know the
>> comparison of failures between runs can be done with
>> tools/compare-failures. It doesn't detect a change in "not run"
>> though, which I would like to detect too.
>>
>> Are you using anything like this you can share?
>
> Ted's xfstests-bld does this sort of stuff, IIRC, using KVM:
>
> https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/
>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com

Thank you, it looks interesting. I see how it works.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
