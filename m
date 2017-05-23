Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42264 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932273AbdEWCYZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 22:24:25 -0400
Subject: Re: [PATCH 2/3] xfsprogs: remove double-underscore integer types
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013138.GV4519@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ab8666d6-7a39-2447-97d3-4c9ed8ce1291@sandeen.net>
Date: Mon, 22 May 2017 21:24:23 -0500
MIME-Version: 1.0
In-Reply-To: <20170518013138.GV4519@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>



On 5/17/17 8:31 PM, Darrick J. Wong wrote:
> This is a purely mechanical patch that removes the private
> __{u,}int{8,16,32,64}_t typedefs in favor of using the system
> {u,}int{8,16,32,64}_t typedefs.  This is the sed script used to perform
> the transformation and fix the resulting whitespace and indentation
> errors:
> 
> s/typedef\t__uint8_t/typedef __uint8_t\t/g
> s/typedef\t__uint/typedef __uint/g
> s/typedef\t__int\([0-9]*\)_t/typedef int\1_t\t/g
> s/__uint8_t\t/__uint8_t\t\t/g
> s/__uint/uint/g
> s/__int\([0-9]*\)_t\t/__int\1_t\t\t/g
> s/__int/int/g
> /^typedef.*int[0-9]*_t;$/d
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I built this in the Fedora buildsystem for a bunch of arches, 

buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, x86_64)
buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, ppc64le)
buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, aarch64)
buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, ppc64)
buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, i686)
buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, s390x)
buildArch (xfsprogs-4.11.0-1.fc25.double.src.rpm, armv7hl) 

and it all completed, for whatever that's worth.  ;)

https://koji.fedoraproject.org/koji/taskinfo?taskID=19698440

I'm fine with this change, too.

I guess that warrants a:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Though "reviewed" might be a bit strong ... :)

-Eric
