Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39584 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754886AbdEIPuE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:50:04 -0400
Subject: Re: [PATCH 1/2 v2] mkfs: unify numeric types of main variables in
 main()
References: <20170419153025.10368-1-jtulak@redhat.com>
 <20170420083323.12524-1-jtulak@redhat.com>
 <62f04d88-9475-b1a4-dd91-871fd091b0e1@sandeen.net>
 <CACj3i72zQBEd18rXi3718xodVfUrRX54Fc9Z0VaJNx8Rn_Eiyw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ca3590ba-a8dc-8c45-03dd-45117fa3bb9c@sandeen.net>
Date: Tue, 9 May 2017 10:49:57 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i72zQBEd18rXi3718xodVfUrRX54Fc9Z0VaJNx8Rn_Eiyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/26/17 2:58 AM, Jan Tulak wrote:
>> so is there any real advantage to converting all of these, only to remove
>> most of them a few patches later?  (If there is, just help me understand
>> why...)
>>
> I wanted to avoid type changes in patches that replace variables in main
> with opts use. Without this, I need to have the opts members in long
> long, but I still get some changes int -> long long and even one or two
> uint -> long long. So I wanted to have all the replaced variables already in a
> single type, without the need to change format strings and knowing
> that the type change is not causing any side effect.

OK, fair enough.

> But I think this shouldn't be a big issue (it doesn't seem that type
> changes broke anything), so I'm rebasing the set without these uint
> changes and the type transition can happen later on.

Your argument above was reasonable, if you want to change them all for
consistency before re-organization, that's ok too.  Either way.

-Eric
 
> Cheers,
> Jan
> 
>> Thanks,
>> -Eric
