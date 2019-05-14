Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49268 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfENUCm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 May 2019 16:02:42 -0400
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4a47cdc4-4a96-cf78-9e48-83d6cd0fe65f@sandeen.net>
Date: Tue, 14 May 2019 15:02:41 -0500
MIME-Version: 1.0
In-Reply-To: <20190514185026.73788-1-jorgeguerra@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>, linux-xfs@vger.kernel.org
Cc: osandov@osandov.com, Jorge Guerra <jorgeguerra@fb.com>

On 5/14/19 1:50 PM, Jorge Guerra wrote:
> +		dbprintf(_("capacity used (bytes): %llu (%.3f %cB)\n"),
> +		extstats.logicalused, answer, iec_prefixes[i]);

I think I missed this instance of "indent please" and probably others...

(I'm kind of wondering about carrying 'used' in bytes, but I suppose we're
ok until we really get zettabyte filesytems in the wild) ;)

-Eric
