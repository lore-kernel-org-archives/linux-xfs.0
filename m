Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753603AbdC1R5N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 13:57:13 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxj_S2UtW0A5vSsmD_1vjgPsdopckj4Jtc5w5KuM2aTppA@mail.gmail.com>
References: <CAOQ4uxj_S2UtW0A5vSsmD_1vjgPsdopckj4Jtc5w5KuM2aTppA@mail.gmail.com> <29458.1490711932@warthog.procyon.org.uk> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <29491.1490712064@warthog.procyon.org.uk> <4DB15765-D097-43B5-9F1B-43DE76D3BC90@sandeen.net>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7094.1490723812.1@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 18:56:52 +0100
Message-ID: <7095.1490723812@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Amir Goldstein <amir73il@gmail.com> wrote:

> That's actually the shortest path for you and there are quite a few
> tests in xfstests that took
> this path. It should be easy for you to copy & paste one of them.

Don't forget that syscall testing for this has to be added to LTP anyway...

David
