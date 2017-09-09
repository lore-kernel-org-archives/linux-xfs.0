Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47728 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757210AbdIICG0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 22:06:26 -0400
Subject: Re: [PATCH] xfsprogs: remove remaining double-underscore integer
 types
References: <20170909015832.32424-1-raj.khem@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0067e494-4404-f808-ff72-ee89ec60aecb@sandeen.net>
Date: Fri, 8 Sep 2017 21:06:25 -0500
MIME-Version: 1.0
In-Reply-To: <20170909015832.32424-1-raj.khem@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>, linux-xfs@vger.kernel.org

On 9/8/17 8:58 PM, Khem Raj wrote:
>  This is a purely mechanical patch that removes the private
>     __{u,}int{8,16,32,64}_t use in favor of using the system
>     provided {u,}int{8,16,32,64}_t typedefs.

As mentioned, this is already present on the for-next branch of xfsprogs-dev:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?h=for-next&id=4a492e72515509ee702286a42afe7d8f89d37636

-Eric
