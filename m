Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 01:11:04 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4V8B0Wt016814
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 01:11:01 -0700
Message-ID: <465E8313.20309@suse.cz>
Date: Thu, 31 May 2007 10:10:59 +0200
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz> <20070530170530.GA4197@tuatara.stupidest.org> <200705302348.54259.arnd@arndb.de>
In-Reply-To: <200705302348.54259.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 30 May 2007, Chris Wedgwood wrote:
>> On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:
>>
>>> +typedef struct xfs_fsop_geom_v132 {
>> wouldn't xfs_fsop_geom_v1_32
...
>> and xfs_fsop_geom_v1_32_t
>>                     ^
>>
>> read better there?
> 
> Actually, the current convention would be struct compat_xfs_fsop_geom_v1
> and compat_xfs_fsop_geom_v1_t.

I see. I'll change it to struct compat_xfs_*.

Michal
