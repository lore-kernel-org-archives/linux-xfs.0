Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E664D29DF5
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:47:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5BE6304032
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 11:47:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Rl0UTPYBLtU64DL9 for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 11:47:48 -0800 (PST)
Subject: Re: State of ext4 auto_da_alloc-like workarounds in XFS
References: <20151221183726.GC482@hape.internal>
	<5678497F.1020104@sandeen.net> <20151221193724.GD482@hape.internal>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56785763.40905@sandeen.net>
Date: Mon, 21 Dec 2015 13:47:47 -0600
MIME-Version: 1.0
In-Reply-To: <20151221193724.GD482@hape.internal>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Russell Cattelan <cattelan@thebarn.com>



On 12/21/15 1:37 PM, Vallo Kallaste wrote:
> On Mon, Dec 21, 2015 at 12:48:31PM -0600, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> [...]
>>> I'd like to know the current state of ext4 auto_da_alloc-like workarounds in XFS,
>>> particularly for RHEL7. Considering the two cases in
>>> https://en.wikipedia.org/wiki/Ext4#Delayed_allocation_and_potential_data_loss
>>> is XFS behaving the same as ext4, both mounted with default options?
>>
>> The sync-on-close-after-file-got-truncated case has been handled since 2007; see
>>
>> https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/commit/?id=ba87ea699ebd9dd577bf055ebc4a98200e337542
>>
>> The sync-after-rename behavior was suggested and rejected for xfs, see
>>
>> http://marc.info/?t=139845506300002&r=1&w=2
>>
>> If you'd like to add this information to the XFS wiki, please do so!
> 
> Thanks, this is an exemplary answer, not to mention lightning fast as well!
> 
> I would consider if Wiki had at http://xfs.org/index.php/Special:RequestAccount page:
> * Privacy policy http://xfs.org/index.php/XFS.org:Privacy_policy
> * Terms of Service http://xfs.org/index.php?title=XFS.org:Terms_of_Service&action=edit&redlink=1
> 
> The latter being something I must read and agree on before I can request a user
> account.

Hohum...

Russell, can you either remove the requirement for reading a nonexistent page, or
add that page?

Thanks,
-Eric

> BR,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
