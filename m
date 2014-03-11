Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3059A7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 20:21:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1A8FAC004
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 18:21:54 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id khWj2x4NHYn9sDdh for
	<xfs@oss.sgi.com>; Mon, 10 Mar 2014 18:21:52 -0700 (PDT)
Message-ID: <531E64AB.60204@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 09:19:39 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<531E15EA.9020903@fb.com>
In-Reply-To: <531E15EA.9020903@fb.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 03/11/2014 03:43 AM, Josef Bacik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 03/09/2014 11:44 PM, Wang Shilong wrote:
>> Test flow is to run fsstress after triggering quota rescan. the
>> ruler is simple, we just remove all files and directories, sync
>> filesystem and see if qgroup's ref and excl are nodesize.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com> ---
>> v1->v2: switch into new helper _run_btrfs_util_prog() ---
>> tests/btrfs/041     | 76
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> tests/btrfs/041.out |  3 +++ tests/btrfs/group   |  1 + 3 files
>> changed, 80 insertions(+) create mode 100644 tests/btrfs/041 create
>> mode 100644 tests/btrfs/041.out
>>
> So this doesn't pass for me but it's not because we're broken, it's
> because the test is broken.  What you should do is run sync after you
> do the rm, and then capture the output of btrfs qgroup show, and then
> do the rescan and redo qgroup show and make sure the numbers match.  I
> did this in my qgroup test, you can look there as an example.  Thanks,
Let's take a look at my test flows:

step1: write some random data to fs tree and then create a snapshot of 
fs tree.

step2: also try to write some random data to newly created snapshot.

step3: enable quota and wait quota rescan finished.(btrfs quota rescan -w)

step4: remove all files and sync btrfs filesystem.

So i did a simple test that if we don't create snapshot here, i get 
qgroup accounting
right here, so i think it is realted to qgroup accounting that differs 
'refer' and 'excl'.

Thanks,
Wang
>
> Josef
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQIcBAEBAgAGBQJTHhXkAAoJEANb+wAKly3BQI8QAIEFXMPrFEJxj9uKuwnBZSSC
> r4g7pHyac82EJA3T/jx+KIzH3aeUz0r1mEg8sYXXACAW5BZguyhe1LR0rU2ZBDaP
> 9ilgWwCVm3d3EhiDmZJDCZueB7IXqE4/GX6D1zyF9OxVNk3Ng9gOY0/3G7Rb52FI
> UTT/UhA8f3mFHQq4DbOebfacu8wbMH9rjHucxgin63UQLx9J9k+3lv5Y7AHihSrX
> 3ly+B9+wqu9zl8gQGhxyvdayWeka6Hr43lkniaOehuW118WjjwIivE/CbTkla/3f
> P3hoJSbUiqlCPONKkfGExYsIny0y9I3igMnLqs58RLeyd4+iSF1O4wFyFGn6hnDy
> sazS8mz4V3PqnfHAj0D3scSYVyYvcrHcUU5WGs+0JiyExfQPFSrbybfwncIgbBg6
> +63iqd7qHwwjClSVNckFurU4B+lj1aVyyk/S1/Z2jN/9s3nrM3/WAR3cqJGIuNyT
> RPT9mzmkc1OICO0+dvwHMol894CCVh9b0iQ6e2NBWYmEfv3BIj9tZNjUZ/ySJdQC
> h2f00uLovRPazI/X/gKVraHj13Go3giL5LCIbnUso/B18iA2V3qyyXGPMBTB1Rws
> wzaxlXsC8cZsMUgFkg7z6Q1Kc9hyUj4AF3Vg/qZze4F216LLAOa9Bni5CxKOVytk
> MPlXItpXYAEX8orapQdO
> =/ZGH
> -----END PGP SIGNATURE-----
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
