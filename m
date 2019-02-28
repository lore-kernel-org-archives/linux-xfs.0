Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49506 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfB1Hvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Feb 2019 02:51:47 -0500
Subject: Re: [PATCH V15 14/18] block: enable multipage bvecs
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <01155e88-f021-fbe2-d048-42e303fe2935@samsung.com>
Date: Thu, 28 Feb 2019 08:51:40 +0100
MIME-Version: 1.0
In-Reply-To: <20190227232940.GA13319@ming.t460p>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
References: <20190215111324.30129-1-ming.lei@redhat.com>
        <20190215111324.30129-15-ming.lei@redhat.com>
        <CGME20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d@eucas1p1.samsung.com>
        <6c9ae4de-c56f-a2b3-2542-da7d8b95601d@samsung.com>
        <0dbbee64-5c6b-0374-4360-6dc218c70d58@nvidia.com>
        <20190227232940.GA13319@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Jon Hunter <jonathanh@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Ulf Hansson <ulf.hansson@linaro.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, 'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, linux-tegra <linux-tegra@vger.kernel.org>

Hi Ming,

On 2019-02-28 00:29, Ming Lei wrote:
> On Wed, Feb 27, 2019 at 08:47:09PM +0000, Jon Hunter wrote:
>> On 21/02/2019 08:42, Marek Szyprowski wrote:
>>> On 2019-02-15 12:13, Ming Lei wrote:
>>>> This patch pulls the trigger for multi-page bvecs.
>>>>
>>>> Reviewed-by: Omar Sandoval <osandov@fb.com>
>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> Since Linux next-20190218 I've observed problems with block layer on one
>>> of my test devices (Odroid U3 with EXT4 rootfs on SD card). Bisecting
>>> this issue led me to this change. This is also the first linux-next
>>> release with this change merged. The issue is fully reproducible and can
>>> be observed in the following kernel log:
>>>
>>> sdhci: Secure Digital Host Controller Interface driver
>>> sdhci: Copyright(c) Pierre Ossman
>>> s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (100000000 Hz)
>>> s3c-sdhci 12530000.sdhci: Got CD GPIO
>>> mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
>>> mmc0: new high speed SDHC card at address aaaa
>>> mmcblk0: mmc0:aaaa SL16G 14.8 GiB
>> I have also noticed some failures when writing to an eMMC device on one
>> of our Tegra boards. We have a simple eMMC write/read test and it is
>> currently failing because the data written does not match the source.
>>
>> I did not seem the same crash as reported here, however, in our case the
>> rootfs is NFS mounted and so probably would not. However, the bisect
>> points to this commit and reverting on top of -next fixes the issues.
> It is sdhci, probably related with max segment size, could you test the
> following patch:
>
> https://marc.info/?l=linux-mmc&m=155128334122951&w=2

This seems to be fixing my issue too! Thanks!

It also fixed the boot issue from USB stick (Exynos EHCI / Mass
Storage), but I suspect that reading the partition table from the sd
card (which hold the bootloader and thus must be present to boot the
device) was enough to trash memory/page cache and break the boot process.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
