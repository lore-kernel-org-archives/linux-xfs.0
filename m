Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13EBA7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 11:14:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E687D8F8064
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 09:14:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jfEE3hJ3BlTpjckb for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 09:14:09 -0700 (PDT)
Message-ID: <525EBB50.1010001@sandeen.net>
Date: Wed, 16 Oct 2013 11:14:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
	<1381938761-31625-1-git-send-email-fdmanana@gmail.com>
	<525EBA40.4020401@sandeen.net>
	<CAL3q7H6RZ+7tc+XwT6YkhNvoBfj9Kh5mfZbbP2Gp=T_8w0cXgw@mail.gmail.com>
In-Reply-To: <CAL3q7H6RZ+7tc+XwT6YkhNvoBfj9Kh5mfZbbP2Gp=T_8w0cXgw@mail.gmail.com>
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
To: fdmanana@gmail.com
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 10/16/13 11:11 AM, Filipe David Manana wrote:
> On Wed, Oct 16, 2013 at 5:09 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 10/16/13 10:52 AM, Filipe David Borba Manana wrote:
>>> This test is motivated by an issue found by a btrfs user, addressed
>>> and described by the following GNU/Linux kernel patch:
>>>
>>> https://patchwork.kernel.org/patch/3046931/
>>>
>>> The steps to reproduce the issue on btrfs are the following:
>>>
>>> $ mkfs.btrfs -f /dev/loop0
>>> $ mount /dev/loop0 /mnt
>>> $ mkdir /mnt/acl
>>> $ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
>>> $ getfacl /mnt/acl
>>> user::rwx
>>> group::rwx
>>> other::r-x
>>> default:user::rwx
>>> default:group::rwx
>>> default:other::---
>>>
>>> $ mkdir /mnt/acl/dir1
>>> $ getfacl /mnt/acl/dir1
>>> user::rwx
>>> group::rwx
>>> other::---
>>>
>>> After unmounting and mounting again the filesystem, getfacl returned the
>>> expected default ACL for the subdirectory:
>>>
>>> $ umount /mnt/acl
>>> $ mount /dev/loop0 /mnt
>>> $ getfacl /mnt/acl/dir1
>>> user::rwx
>>> group::rwx
>>> other::---
>>> default:user::rwx
>>> default:group::rwx
>>> default:other::---
>>>
>>> This means that the underlying ACL xattr was persisted correctly but
>>> the in memory representation of the inode had (incorrectly) a NULL ACL.
>>>
>>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>>> ---
>>>
>>> V2: Moved the regression test into a dedicated and new file, as suggested
>>>     by Eric Sandeen.
>>
>> Great, thanks.  Verified that it succeeds on xfs & ext3 as well.
>>
>> It also fails properly when mounting ext3 -o noacl:
>>
>> shared/052 1s ... [not run] ACLs not supported by this filesystem type: ext3
>>
>> ...
>>
>>> +# real QA test starts here
>>> +_supported_os Linux
>>
>> Technically this should have a:
>>
>> +_supported_fs generic
>>
>> here.  And then it can move to tests/generic/xxx
>>
>> (I guess that's a little odd and redundant, and it does
>> run today w/o the _supported_fs, I guess, but still
>> best to be consistent).
>>
>> Sorry for the runaround :)
>>
>> If you don't mind a V3, we'll be done,  I think!
> 
> Np.
> Is there any rule as for which name (number) to pick for the test case
> file name?

just pick a free slot.  SGI is behind on merging, so they may need to move
it to avoid a conflict.  Wish we had a little better way to do this...

hch just chimed in, maybe we can tweak the original 051 test to do the
same testing on other filesystems, if we can set the appropriate max
acl counts... but that's another patch.

-Eric

>>
>> -Eric
>>
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
