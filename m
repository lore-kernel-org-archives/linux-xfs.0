Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89B307F55
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 07:39:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01AB9AC003
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 05:39:27 -0800 (PST)
Received: from mail-bk0-f41.google.com (mail-bk0-f41.google.com
	[209.85.214.41]) by cuda.sgi.com with ESMTP id 6PukjWC8bw4eYAoe
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Feb 2014 05:39:25 -0800 (PST)
Received: by mail-bk0-f41.google.com with SMTP id na10so3589736bkb.28
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 05:39:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140214134656.7c1f2544@plati.site>
References: <1391769341-20688-1-git-send-email-ddiss@suse.de>
	<20140214134656.7c1f2544@plati.site>
Date: Fri, 14 Feb 2014 13:39:24 +0000
Message-ID: <CAL3q7H7f0xSnny1B75bhztsYxM1n92aUpNDqwTaF60BVGo2zFA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] __btrfs_drop_extents() BUG_ON reproducer
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
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
To: David Disseldorp <ddiss@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Feb 14, 2014 at 12:46 PM, David Disseldorp <ddiss@suse.de> wrote:
> Ping, any Btrfsers get a chance to look at this patch series?
> I'd like to get it into the QA tree.

If no one else gets there first, I'll take a look at it soon.
thanks

>
> On Fri,  7 Feb 2014 11:35:38 +0100, David Disseldorp wrote:
>
>> This patch-set provides a reproducer for hitting the 3.14.0-rc1 BUG_ON()
>> at:
>>  692 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>> ...
>>  839                 /*
>>  840                  *  | ---- range to drop ----- |
>>  841                  *      | -------- extent -------- |
>>  842                  */
>>  843                 if (start <= key.offset && end < extent_end) {
>>  844                         BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
>>  845
>>  846                         memcpy(&new_key, &key, sizeof(new_key));
>>
>> The first patch adds a small cloner binary which is used by btrfs/035 to
>> dispatch BTRFS_IOC_CLONE_RANGE requests.
>>
>> This workload resembles that of Samba's vfs_btrfs module, when a Windows
>> client restores a file from a shadow-copy (snapshot) using server-side
>> copy requests.
>>
>> Changes since V2:
>> - Remove explicit write error checks
>>
>> Changes since V1:
>> - Use strtoull instead of atoi
>> - Print error conditions in cloner
>> - Check for cloner binary before running test
>> - Continue test on failure
>> - Add cloner to .gitignore
>>
>> Feedback appreciated.
>>
>> Cheers, David
>>
>>
>>  .gitignore          |   1 +
>>  configure.ac        |   1 +
>>  src/Makefile        |   2 +-
>>  src/cloner.c        | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/035     |  77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/035.out |   3 +++
>>  tests/btrfs/group   |   1 +
>>  7 files changed, 276 insertions(+), 1 deletion(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
