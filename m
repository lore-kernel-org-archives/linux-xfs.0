Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56110 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbeG1ROr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 28 Jul 2018 13:14:47 -0400
Subject: Re: [PATCH] xfs: add debian initramfs hook to package
References: <20180726215154.GI30972@magnolia>
 <f2b317ec-3541-4441-cf11-58602eb8de4f@sandeen.net>
 <20180728074406.GQ30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ea774c75-8401-e672-c8cf-43d2879753d4@sandeen.net>
Date: Sat, 28 Jul 2018 08:47:49 -0700
MIME-Version: 1.0
In-Reply-To: <20180728074406.GQ30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>



On 7/28/18 12:44 AM, Darrick J. Wong wrote:
>> Actually... this sort of fstqab poses a problem for your function and mine:
>>
>> #/dev/mapper/vg-lv_root /                      xfs    defaults        1 1
>> /dev/mapper/vg-lv_root /                       ext4    defaults        1 1
>>
>> because it'll happily pick xfs.  Need to exclude comment lines, so exclude
>> MNT_FSNAME starting with # - 
>>
>> test ${MNT_FSNAME::1} == "#" && continue
>>
>> or in my fancy world could do:
>>
>> awk '(!/^#/) && ($2 == "/") {print $3}' $(fstab_files)
>>
>> tho I guess mine assumes only one matching line... | head -n 1 ;)
> Might have to add awk as a Depends: dependency in debian/control if you
> do that.  I think it's cleaner....
> 

Ok, up to you.  If this is all just boilerplate from other debian
scripts and it's good enough for them I guess I can just merge as
is.  The only thing that seemed to matter was not ignoring comment lines,
which would be trivial to fix.

-Eric
