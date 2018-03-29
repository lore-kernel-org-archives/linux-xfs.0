Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58306 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeC2N0Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 09:26:24 -0400
Subject: Re: [PATCH V3] xfs: do not log/recover swapext extent owner changes
 for deleted inodes
References: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
 <0b3a812e-9bab-aa93-f16b-081a91eddbef@sandeen.net>
 <20180329131917.GA3473@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <000a96bf-1bd1-e883-d210-09427f241045@sandeen.net>
Date: Thu, 29 Mar 2018 08:26:21 -0500
MIME-Version: 1.0
In-Reply-To: <20180329131917.GA3473@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 3/29/18 8:19 AM, Brian Foster wrote:
> On Wed, Mar 28, 2018 at 05:12:44PM -0500, Eric Sandeen wrote:
>> Today if we run xfs_fsr and crash[1], log replay can fail because
>> the recovery code tries to instantiate the donor inode from
>> disk to replay the swapext, but it's been deleted and we get
>> verifier failures when we try to read the inode off disk with
>> i_mode == 0.
>>
>> This fixes both sides: We don't log the swapext change if the
>> inode has been deleted, and we don't try to recover it either.
>>
>> [1] or if systemd doesn't uncleanly unmount root, as is its wont
>>     to do ...
> 
> Eh? :P

Obviously I meant to say "doesn't not uncleanly unmount" ... o_O
