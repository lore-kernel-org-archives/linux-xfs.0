Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60202 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbcI0ROp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 13:14:45 -0400
Subject: Re: Clarification required about xfs_metadump and xfs_mdrestore
References: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
 <20160927170443.GR9314@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b822c949-ba38-f37e-a79a-8ab7d048839e@sandeen.net>
Date: Tue, 27 Sep 2016 12:14:44 -0500
MIME-Version: 1.0
In-Reply-To: <20160927170443.GR9314@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>

On 9/27/16 12:04 PM, Darrick J. Wong wrote:
> On Tue, Sep 27, 2016 at 09:49:11AM -0400, murali krishna wrote:
>> Hi All,
>>
>> Got your email id from Nathan Scott.
>>
>> Could you please clarify the reasons behind stating below statement in
>> xfs_metadump man page.
>>
>>
>>
>> *xfs_metadump should not be used for any purposes other than for
>>  debugging and reporting filesystem problems*
>> Man page: http://man7.org/linux/man-pages/man8/xfs_metadump.8.html
>>
>> I am trying to encrypt my existing xfs drive (/dev/sda2) and would like to
>> backup metadata using xfs_metadump and restore it back using xfs_mdrestore
>> after encrypting my drive. In order to retain entire contents of my
>> realtime partition (/dev/sda1), I need to perform this step.
>>
>> Can I use xfs_metadump to backup meta-data of xfs  and restore it back
>> successfully ?
>> Why xfs_metadump should be specifically used as debugging tool ? Please
>> clarify ?
> 
> Uh.... if your goal is to back up data, reformat the storage with a crypto
> layer, and then restore the data, why not just use xfsdump/xfsrestore?
> Your data will end up all nicely defragmented, too.

Right, sorry - if you want to migrate to an encrypted block device, use
dump & restore.  Sorry, the metadata-restoration scheme confused me.  :)

-eric

> --D
> 
>>
>> Thanks in Advance,
>> Murali
