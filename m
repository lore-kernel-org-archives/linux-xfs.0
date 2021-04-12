Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65BEC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D85561350
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbhDLN4V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238999AbhDLN4V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Apr 2021 09:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E99F6134F;
        Mon, 12 Apr 2021 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618235763;
        bh=QehX3LmcBycLdCoRnQbKS1YynLf1YvTjCdoqGx/+87Y=;
        h=Date:From:To:Cc:Subject:From;
        b=un1bgcHE/q3Jqmetj/tms6OCKEQjKiSnlx3hs8DhL4BpVIT0KXu5l/1AzJkYAgCAS
         DPNiblFZbTaKK7H1WtExq4CYBdP1WuMKBv1L5PUzAEP52OCqawnwocTY7klRgC8tA5
         Z8Nlv699Bxuv85PFjcPrAK22DOye8QWSnmS2mfgdnuzr7Z5hzRo32kas8uic2nWURb
         cfL+ggPUfBT+2dgCYuiEY7+mMhvw6ORizrjmlrJXgkNV5Au/kQWg5hESCht6P4nRZA
         bY529PkY3FrBdC9XUnDScmTsUgYgv0QcewOUPBw3xcVRHdTP+O+pYSKtYDIMGkwHdP
         6d5eOhIhOTBFw==
Date:   Mon, 12 Apr 2021 08:56:11 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v4][next] xfs: Replace one-element arrays with flexible-array
 members
Message-ID: <20210412135611.GA183224@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of flexible-array members in
multiple structures, instead of one-element arrays. Also, make use of
the new struct_size() helper to properly calculate the size of multiple
structures that contain flexible-array members. Additionally, wrap
some calls to the struct_size() helper in multiple inline functions.

Below are the results of running xfstests for "all" with the following
configuration in local.config:

export TEST_DEV=/dev/sdb1
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/sdb2
export SCRATCH_MNT=/mnt/scratch

The size for both partitions /dev/sdb1 and /dev/sdb2 is 25GB.

These are the results of running ./check -g all on 5.12.0-rc6 kernel:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 machine 5.12.0-rc6-xfs-fixed+ #16 SMP Fri Apr 9 22:42:49 CDT 2021
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb2
MOUNT_OPTIONS -- /dev/sdb2 /mnt/scratch

generic/001 3s ...  4s
generic/002 0s ...  2s
generic/003 10s ...  10s
generic/004 1s ...  2s
generic/005 1s ...  1s
generic/006 1s ...  2s
generic/007 2s ...  2s
generic/008 1s ...  1s
generic/009 2s ...  1s
generic/010	[not run] /home/test/git/xfstests/src/dbtest not built
generic/011 2s ...  1s
generic/012 2s ...  1s
generic/013 8s ...  7s
generic/014 1s ...  1s
generic/015 1s ...  1s
generic/016 1s ...  1s
generic/017 56s ...  54s
generic/018 2s ...  2s
generic/019	[not run] /sys/kernel/debug/fail_make_request  not found. Seems that CONFIG_FAULT_INJECTION_DEBUG_FS kernel config option not enabled
generic/020 3s ...  4s
generic/021 1s ...  1s
generic/022 1s ...  1s
generic/023 1s ...  1s
generic/024 1s ...  1s
generic/025 1s ...  1s
generic/026 3s ...  4s
generic/027 30s ...  29s
generic/028 6s ...  6s
generic/029 0s ...  1s
generic/030 1s ...  1s
generic/031 1s ...  0s
generic/032 9s ...  8s
generic/033 0s ...  1s
generic/034 1s ...  1s
generic/035 1s ...  1s
generic/036 11s ...  11s
generic/037 6s ...  5s
generic/038	[not run] FITRIM not supported on /mnt/scratch
generic/039 1s ...  1s
generic/040 5s ...  6s
generic/041 9s ...  8s
generic/042 2s ...  2s
generic/043 14s ...  14s
generic/044 17s ...  17s
generic/045 23s ...  23s
generic/046 16s ...  17s
generic/047 22s ...  21s
generic/048 22s ...  22s
generic/049 14s ...  14s
generic/050 1s ...  0s
generic/051 75s ...  75s
generic/052 1s ...  1s
generic/053 1s ...  1s
generic/054 19s ...  18s
generic/055 9s ...  10s
generic/056 1s ...  1s
generic/057 1s ...  1s
generic/058 1s ...  1s
generic/059 2s ...  2s
generic/060 1s ...  1s
generic/061 1s ...  1s
generic/062 2s ...  1s
generic/063 1s ...  1s
generic/064 1s ...  2s
generic/065 1s ...  1s
generic/066 1s ...  1s
generic/067 1s ...  1s
generic/068 43s ...  43s
generic/069 4s ...  3s
generic/070 2s ...  3s
generic/071 1s ...  0s
generic/072 13s ...  14s
generic/073 1s ...  0s
generic/074 11s ...  11s
generic/075 15s ...  15s
generic/076 2s ...  2s
generic/077 6s ...  5s
generic/078 1s ...  2s
generic/079 1s ...  0s
generic/080 3s ...  3s
generic/081	[not run] lvm utility required, skipped this test
generic/082 1s ...  1s
generic/083 7s ...  6s
generic/084 5s ...  6s
generic/085 5s ...  5s
generic/086 1s ...  1s
generic/087 1s ...  1s
generic/088 1s ...  1s
generic/089 7s ...  8s
generic/090 2s ...  1s
generic/091 6s ...  7s
generic/092 0s ...  0s
generic/093 1s ...  1s
generic/094 8s ...  9s
generic/095 4s ...  3s
generic/096 1s ...  0s
generic/097 1s ...  1s
generic/098 1s ...  1s
generic/099 1s ...  1s
generic/100 18s ...  17s
generic/101 0s ...  1s
generic/102 3s ...  3s
generic/103 2s ...  1s
generic/104 1s ...  1s
generic/105 1s ...  1s
generic/106 1s ...  1s
generic/107 1s ...  1s
generic/108	[not run] lvm utility required, skipped this test
generic/109 2s ...  1s
generic/110 2s ...  1s
generic/111 1s ...  1s
generic/112 16s ...  16s
generic/113 13s ...  13s
generic/114 3s ...  2s
generic/115 1s ...  1s
generic/116 1s ...  1s
generic/117 2s ...  2s
generic/118 1s ...  1s
generic/119 1s ...  1s
generic/120 16s ...  16s
generic/121 1s ...  1s
generic/122 1s ...  1s
generic/123 1s ...  1s
generic/124 3s ...  3s
generic/125 62s ...  62s
generic/126 0s ...  1s
generic/127 210s ...  216s
generic/128 1s ...  1s
generic/129 2s ...  2s
generic/130 3s ...  3s
generic/131 2s ...  2s
generic/132 12s ...  12s
generic/133 11s ...  12s
generic/134 1s ...  1s
generic/135 1s ...  1s
generic/136 1s ...  1s
generic/137 23s ...  22s
generic/138 1s ...  1s
generic/139 1s ...  1s
generic/140 1s ...  1s
generic/141 1s ...  1s
generic/142 2s ...  1s
generic/143 5s ...  5s
generic/144 3s ...  2s
generic/145 2s ...  2s
generic/146 3s ...  2s
generic/147 2s ...  1s
generic/148 1s ...  1s
generic/149 2s ...  1s
generic/150 2s ...  1s
generic/151 3s ...  1s
generic/152 2s ...  1s
generic/153 3s ...  1s
generic/154 3s ...  1s
generic/155 3s ...  2s
generic/156 3s ...  2s
generic/157 1s ...  2s
generic/158 2s ...  1s
generic/159 1s ...  1s
generic/160 1s ...  1s
generic/161 1s ...  1s
generic/162 8s ...  8s
generic/163 10s ...  9s
generic/164 10s ...  11s
generic/165 10s ...  10s
generic/166 9s ...  10s
generic/167 7s ...  7s
generic/168 41s ...  41s
generic/169 1s ...  1s
generic/170 47s ...  48s
generic/171 1s ...  1s
generic/172 2s ...  2s
generic/173 2s ...  2s
generic/174 1s ...  1s
generic/175 21s ...  20s
generic/176 45s ...  44s
generic/177 1s ...  1s
generic/178 1s ...  1s
generic/179 1s ...  1s
generic/180 1s ...  1s
generic/181 1s ...  1s
generic/182 2s ...  1s
generic/183 1s ...  2s
generic/184 1s ...  1s
generic/185 1s ...  1s
generic/186 21s ...  20s
generic/187 21s ...  20s
generic/188 1s ...  2s
generic/189 1s ...  1s
generic/190 2s ...  1s
generic/191 1s ...  1s
generic/192 6s ...  5s
generic/193 1s ...  2s
generic/194 2s ...  1s
generic/195 1s ...  2s
generic/196 2s ...  1s
generic/197 1s ...  1s
generic/198 1s ...  1s
generic/199 1s ...  2s
generic/200 2s ...  1s
generic/201 1s ...  2s
generic/202 1s ...  1s
generic/203 1s ... [failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//generic/203.out.bad)
    --- tests/generic/203.out	2021-02-28 21:47:48.606582461 -0600
    +++ /home/test/git/xfstests/results//generic/203.out.bad	2021-04-11 22:48:59.977013978 -0500
    __ -1,12 +1,7 __
     QA output created by 203
     Format and mount
     Create the original files
    -Compare files
    -75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-203/file1
    -75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-203/file2
    -75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-203/file2.chk
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/203.out /home/test/git/xfstests/results//generic/203.out.bad'  to see the entire diff)
generic/204 23s ...  22s
generic/205	[not run] Failed to format with small blocksize.
generic/206	[not run] Failed to format with small blocksize.
generic/207 1s ...  2s
generic/208 201s ...  200s
generic/209 32s ...  31s
generic/210 1s ...  1s
generic/211 1s ...  1s
generic/212 1s ...  0s
generic/213 0s ...  1s
generic/214 1s ...  1s
generic/215 3s ...  3s
generic/216	[not run] Failed to format with small blocksize.
generic/217	[not run] Failed to format with small blocksize.
generic/218	[not run] Failed to format with small blocksize.
generic/219 1s ...  1s
generic/220	[not run] Failed to format with small blocksize.
generic/221 1s ...  2s
generic/222	[not run] Failed to format with small blocksize.
generic/223 3s ...  3s
generic/224 8s ...  7s
generic/225 9s ...  8s
generic/226 2s ...  2s
generic/227	[not run] Failed to format with small blocksize.
generic/228 1s ...  1s
generic/229	[not run] Failed to format with small blocksize.
generic/230 13s ...  13s
generic/231 73s ...  74s
generic/232 4s ...  5s
generic/233 4s ...  4s
generic/234 8s ...  8s
generic/235 1s ...  1s
generic/236 2s ...  2s
generic/237 0s ...  0s
generic/238	[not run] Failed to format with small blocksize.
generic/239 25s ...  20s
generic/240 1s ...  1s
generic/241 74s ...  73s
generic/242 7s ...  8s
generic/243 7s ...  7s
generic/244 4s ...  3s
generic/245 0s ...  1s
generic/246 1s ...  1s
generic/247 5s ...  5s
generic/248 1s ...  1s
generic/249 1s ...  1s
generic/250 2s ...  2s
generic/251	[not run] FITRIM not supported on /mnt/scratch
generic/252 2s ...  2s
generic/253 1s ... [failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//generic/253.out.bad)
    --- tests/generic/253.out	2021-02-28 21:47:48.606582461 -0600
    +++ /home/test/git/xfstests/results//generic/253.out.bad	2021-04-11 22:57:45.916411410 -0500
    __ -6,7 +6,7 __
     c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file2
     c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file2.chk
     CoW and unmount
    -Compare files
    -c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file1
    -b5fc98f04b19fa7b2085ec1358c78760  SCRATCH_MNT/test-253/file2
    -b5fc98f04b19fa7b2085ec1358c78760  SCRATCH_MNT/test-253/file2.chk
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/253.out /home/test/git/xfstests/results//generic/253.out.bad'  to see the entire diff)
generic/254 1s ...  1s
generic/255 1s ...  2s
generic/256 51s ...  53s
generic/257 1s ...  1s
generic/258 1s ...  1s
generic/259 1s ...  1s
generic/260	[not run] FITRIM not supported on /mnt/scratch
generic/261 1s ...  1s
generic/262 1s ...  1s
generic/263 12s ...  12s
generic/264 1s ...  1s
generic/265 2s ...  2s
generic/266 2s ...  2s
generic/267 1s ...  2s
generic/268 2s ...  2s
generic/269 22s ...  24s
generic/270 39s ...  38s
generic/271 2s ...  3s
generic/272 1s ...  2s
generic/273 8s ...  9s
generic/274 7s ...  7s
generic/275 2s ...  3s
generic/276 2s ...  2s
generic/277 2s ...  2s
generic/278 2s ...  2s
generic/279 1s ...  2s
generic/280 2s ...  2s
generic/281 2s ...  2s
generic/282 2s ...  1s
generic/283 3s ...  4s
generic/284 1s ...  1s
generic/285 1s ...  3s
generic/286 2s ...  2s
generic/287 1s ...  2s
generic/288	[not run] FITRIM not supported on /mnt/scratch
generic/289 1s ...  2s
generic/290 2s ...  1s
generic/291 1s ...  2s
generic/292 1s ...  2s
generic/293 1s ...  2s
generic/294 1s ...  1s
generic/295 1s ...  2s
generic/296 2s ...  1s
generic/297 41s ...  42s
generic/298 42s ...  42s
generic/299 108s ...  112s
generic/300 5s ...  4s
generic/301 2s ...  1s
generic/302 3s ...  4s
generic/303 1s ...  2s
generic/304 1s ...  2s
generic/305 1s ...  1s
generic/306 1s ...  2s
generic/307 2s ...  2s
generic/308 1s ...  1s
generic/309 2s ...  2s
generic/310 64s ...  65s
generic/311 46s ...  45s
generic/312 1s ...  1s
generic/313 5s ...  5s
generic/314 1s ...  2s
generic/315 1s ...  2s
generic/316 1s ...  2s
generic/317 3s ...  1s
generic/318 0s ...  1s
generic/319 0s ...  0s
generic/320 16s ...  14s
generic/321 2s ...  2s
generic/322 1s ...  1s
generic/323 122s ...  122s
generic/324 13s ...  13s
generic/325 1s ...  1s
generic/326 1s ...  1s
generic/327 1s ...  1s
generic/328 2s ...  2s
generic/329 2s ...  1s
generic/330 1s ...  1s
generic/331 2s ...  2s
generic/332 2s ...  2s
generic/333 75s ...  73s
generic/334 69s ...  67s
generic/335 1s ...  1s
generic/336 1s ...  1s
generic/337 1s ...  0s
generic/338 1s ...  1s
generic/339 2s ...  3s
generic/340 2s ...  1s
generic/341 1s ...  1s
generic/342 1s ...  1s
generic/343 1s ...  1s
generic/344 2s ...  2s
generic/345 2s ...  3s
generic/346 2s ...  1s
generic/347 70s ...  71s
generic/348 1s ...  1s
generic/349 2s ...  2s
generic/350 2s ...  2s
generic/351 4s ...  3s
generic/352 26s ...  24s
generic/353 1s ...  1s
generic/354 2s ...  2s
generic/355 1s ...  1s
generic/356 1s ...  1s
generic/357 2s ...  1s
generic/358 7s ...  7s
generic/359 1s ...  1s
generic/360 1s ...  1s
generic/361 1s ...  1s
generic/362	[not run] mkfs.xfs doesn't have richacl feature
generic/363	[not run] mkfs.xfs doesn't have richacl feature
generic/364	[not run] mkfs.xfs doesn't have richacl feature
generic/365	[not run] mkfs.xfs doesn't have richacl feature
generic/366	[not run] mkfs.xfs doesn't have richacl feature
generic/367	[not run] mkfs.xfs doesn't have richacl feature
generic/368	[not run] mkfs.xfs doesn't have richacl feature
generic/369	[not run] mkfs.xfs doesn't have richacl feature
generic/370	[not run] mkfs.xfs doesn't have richacl feature
generic/371 5s ...  5s
generic/372 1s ...  1s
generic/373 1s ...  1s
generic/374 1s ...  1s
generic/375 1s ...  1s
generic/376 1s ...  1s
generic/377 1s ...  1s
generic/378 1s ...  1s
generic/379 1s ...  1s
generic/380 3s ...  3s
generic/381 1s ...  1s
generic/382 6s ...  3s
generic/383 0s ...  0s
generic/384 1s ...  1s
generic/385 2s ...  2s
generic/386 1s ...  0s
generic/387 50s ...  49s
generic/388 78s ... [failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//generic/388.out.bad)
    --- tests/generic/388.out	2021-02-28 21:47:48.614581906 -0600
    +++ /home/test/git/xfstests/results//generic/388.out.bad	2021-04-11 23:16:57.210310505 -0500
    __ -1,2 +1,6 __
     QA output created by 388
     Silence is golden.
    +umount: /mnt/scratch: target is busy.
    +mount: /mnt/scratch: /dev/sdb2 already mounted on /mnt/scratch.
    +cycle mount failed
    +(see /home/test/git/xfstests/results//generic/388.full for details)
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/388.out /home/test/git/xfstests/results//generic/388.out.bad'  to see the entire diff)
generic/389 1s ...  1s
generic/390 15s ...  15s
generic/391 3s ...  4s
generic/392 4s ...  3s
generic/393 1s ...  1s
generic/394 1s ...  1s
generic/395	[not run] No encryption support for xfs
generic/396	[not run] No encryption support for xfs
generic/397	[not run] No encryption support for xfs
generic/398	[not run] No encryption support for xfs
generic/399	[not run] No encryption support for xfs
generic/400 0s ...  0s
generic/401 1s ...  0s
generic/402 1s ...  1s
generic/403 1s ...  1s
generic/404 11s ...  10s
generic/405 62s ...  63s
generic/406 1s ...  1s
generic/407 2s ...  2s
generic/408 2s ...  2s
generic/409 7s ...  6s
generic/410 13s ... umount: /mnt/test: target is busy.
_check_xfs_filesystem: filesystem on /dev/sdb1 has dirty log
(see /home/test/git/xfstests/results//generic/410.full for details)
xfs_check: /dev/sdb1 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library
_check_xfs_filesystem: filesystem on /dev/sdb1 is inconsistent (r)
(see /home/test/git/xfstests/results//generic/410.full for details)
- output mismatch (see /home/test/git/xfstests/results//generic/410.out.bad)
    --- tests/generic/410.out	2021-02-28 21:47:48.618581629 -0600
    +++ /home/test/git/xfstests/results//generic/410.out.bad	2021-04-11 23:19:03.934425780 -0500
    __ -207,6 +207,8 __
     mpC SCRATCH_DEV
     mpC/dir SCRATCH_DEV
     ======
    +umount: /mnt/test/410: target is busy.
    +mount: /mnt/test/410: /dev/sdb2 already mounted on /mnt/test/410.
     make-shared a unbindable mount
     before make-shared run on unbindable
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/410.out /home/test/git/xfstests/results//generic/410.out.bad'  to see the entire diff)
generic/411 1s ...  2s
generic/412 1s ...  0s
generic/413	[not run] mount /dev/sdb2 with dax failed
generic/414 1s ...  1s
generic/415 48s ...  49s
generic/416 107s ...  104s
generic/417 11s ...  12s
generic/418 20s ...  19s
generic/419	[not run] No encryption support for xfs
generic/420 1s ...  1s
generic/421	[not run] No encryption support for xfs
generic/422 1s ...  1s
generic/423 1s ...  1s
generic/424 1s ...  1s
generic/425 2s ...  2s
generic/426 2s ...  1s
generic/427 3s ...  3s
generic/428 2s ...  1s
generic/429	[not run] No encryption support for xfs
generic/430 1s ...  1s
generic/431 1s ...  0s
generic/432 2s ...  1s
generic/433 1s ...  1s
generic/434 1s ...  1s
generic/435	[not run] No encryption support for xfs
generic/436 0s ...  1s
generic/437 29s ...  6s
generic/438 91s ...  92s
generic/439 2s ...  2s
generic/440	[not run] No encryption support for xfs
generic/441 2s ...  2s
generic/442 1s ...  1s
generic/443 2s ...  1s
generic/444 1s ...  0s
generic/445 1s ...  1s
generic/446 8s ...  9s
generic/447 29s ...  29s
generic/448 2s ...  1s
generic/449 20s ...  21s
generic/450 1s ...  1s
generic/451 31s ...  31s
generic/452 1s ...  1s
generic/453 1s ...  0s
generic/454 1s ...  1s
generic/455	[not run] This test requires a valid $LOGWRITES_DEV
generic/456 1s ...  1s
generic/457	[not run] This test requires a valid $LOGWRITES_DEV
generic/458 1s ...  0s
generic/459	[not run] lvm utility required, skipped this test
generic/460 2s ...  1s
generic/461 21s ...  21s
generic/462	[not run] mount /dev/sdb2 with dax failed
generic/463 2s ...  1s
generic/464 55s ...  54s
generic/465 6s ...  5s
generic/466 2s ... [failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//generic/466.out.bad)
    --- tests/generic/466.out	2021-02-28 21:47:48.618581629 -0600
    +++ /home/test/git/xfstests/results//generic/466.out.bad	2021-04-11 23:27:16.513071107 -0500
    __ -1,2 +1,6 __
     QA output created by 466
     Silence is golden
    +umount: /mnt/scratch: target is busy.
    +mount: /mnt/scratch: /dev/sdb2 already mounted on /mnt/scratch.
    +cycle mount failed
    +(see /home/test/git/xfstests/results//generic/466.full for details)
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/466.out /home/test/git/xfstests/results//generic/466.out.bad'  to see the entire diff)
generic/467 2s ...  1s
generic/468 1s ...  2s
generic/469 2s ...  1s
generic/470	[not run] This test requires a valid $LOGWRITES_DEV
generic/471 2s ...  1s
generic/472 1s ...  1s
generic/473	- output mismatch (see /home/test/git/xfstests/results//generic/473.out.bad)
    --- tests/generic/473.out	2021-02-28 21:47:48.618581629 -0600
    +++ /home/test/git/xfstests/results//generic/473.out.bad	2021-04-11 23:27:24.941312327 -0500
    __ -6,7 +6,7 __
     1: [256..287]: hole
     Hole + Data
     0: [0..127]: hole
    -1: [128..255]: data
    +1: [128..135]: data
     Hole + Data + Hole
     0: [0..127]: hole
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/473.out /home/test/git/xfstests/results//generic/473.out.bad'  to see the entire diff)
generic/474 0s ...  1s
generic/475 98s ...  81s
generic/476 179s ...  174s
generic/477 4s ...  2s
generic/478 8s ...  8s
generic/479 2s ...  2s
generic/480 2s ...  1s
generic/481 1s ...  1s
generic/482	[not run] This test requires a valid $LOGWRITES_DEV
generic/483 5s ...  5s
generic/484 2s ...  1s
generic/485 2s ...  1s
generic/486 1s ...  1s
generic/487	[not run] This test requires a valid $SCRATCH_LOGDEV
generic/488 2s ...  1s
generic/489 1s ...  0s
generic/490 2s ...  0s
generic/491 1s ...  1s
generic/492 1s ...  1s
generic/493 2s ...  1s
generic/494 2s ...  1s
generic/495 1s ...  1s
generic/496 3s ...  2s
generic/497 1s ...  1s
generic/498 1s ...  1s
generic/499 1s ...  1s
generic/500	[not run] FITRIM not supported on /mnt/scratch
generic/501 33s ...  33s
generic/502 1s ...  1s
generic/503 7s ...  6s
generic/504 1s ...  0s
generic/505 1s ...  1s
generic/506 2s ...  1s
generic/507	[not run] file system doesn't support chattr +AsSu
generic/508 1s ...  1s
generic/509 1s ...  1s
generic/510 1s ...  0s
generic/511 2s ...  1s
generic/512 1s ...  0s
generic/513 2s ...  2s
generic/514 2s ...  2s
generic/515 1s ...  1s
generic/516 1s ...  1s
generic/517 1s ...  1s
generic/518 1s ...  1s
generic/519 1s ...  1s
generic/520 12s ...  12s
generic/521 549s ...  560s
generic/522 606s ...  616s
generic/523 0s ...  1s
generic/524 2s ...  3s
generic/525 1s ...  0s
generic/526 1s ...  0s
generic/527 1s ...  1s
generic/528 1s ...  1s
generic/529 1s ...  1s
generic/530 3s ...  4s
generic/531 284s ...  269s
generic/532 1s ...  1s
generic/533 0s ...  1s
generic/534 0s ...  1s
generic/535 1s ...  1s
generic/536 1s ...  1s
generic/537	[not run] FSTRIM not supported
generic/538 2s ...  1s
generic/539 1s ...  1s
generic/540 1s ...  2s
generic/541 2s ...  1s
generic/542 1s ...  1s
generic/543 2s ...  2s
generic/544 2s ...  2s
generic/545 1s ...  1s
generic/546 2s ...  1s
generic/547 1s ...  2s
generic/548	[not run] No encryption support for xfs
generic/549	[not run] No encryption support for xfs
generic/550	[not run] No encryption support for xfs
generic/551 57s ...  58s
generic/552 1s ...  1s
generic/553 1s ...  1s
generic/554 1s ...  1s
generic/555 1s ...  1s
generic/556	[not run] xfs does not support casefold feature
generic/557 1s ...  2s
generic/558 69s ...  69s
generic/559	[not run] duperemove utility required, skipped this test
generic/560	[not run] duperemove utility required, skipped this test
generic/561	[not run] duperemove utility required, skipped this test
generic/562 94s ...  92s
generic/563	[not run] cgroup2 not mounted on /sys/fs/cgroup
generic/564 1s ...  1s
generic/565 1s ...  1s
generic/566 9s ...  7s
generic/567 0s ...  1s
generic/568 1s ...  1s
generic/569 1s ...  1s
generic/570	[not run] userspace hibernation to swap is enabled
generic/571 7s ...  7s
generic/572	[not run] fsverity utility required, skipped this test
generic/573	[not run] fsverity utility required, skipped this test
generic/574	[not run] fsverity utility required, skipped this test
generic/575	[not run] fsverity utility required, skipped this test
generic/576	[not run] fsverity utility required, skipped this test
generic/577	[not run] fsverity utility required, skipped this test
generic/578 1s ...  1s
generic/579	[not run] fsverity utility required, skipped this test
generic/580	[not run] No encryption support for xfs
generic/581	[not run] No encryption support for xfs
generic/582	[not run] No encryption support for xfs
generic/583	[not run] No encryption support for xfs
generic/584	[not run] No encryption support for xfs
generic/585 2s ...  1s
generic/586 7s ...  5s
generic/587 2s ...  1s
generic/588 2s ...  2s
generic/589 8s ...  7s
generic/590 19s ...  23s
generic/591 1s ...  1s
generic/592	[not run] No encryption support for xfs
generic/593	[not run] No encryption support for xfs
generic/594	- output mismatch (see /home/test/git/xfstests/results//generic/594.out.bad)
    --- tests/generic/594.out	2021-02-28 21:47:48.622581352 -0600
    +++ /home/test/git/xfstests/results//generic/594.out.bad	2021-04-12 00:02:58.035667398 -0500
    __ -5,31 +5,31 __
     *** Report for group quotas on device SCRATCH_DEV
     Block grace time: DEF_TIME; Inode grace time: DEF_TIME
     *** Report for project quotas on device SCRATCH_DEV
    -Block grace time: 00:10; Inode grace time: 00:20
    +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
     
     2. set group quota timer
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/594.out /home/test/git/xfstests/results//generic/594.out.bad'  to see the entire diff)
generic/595	[not run] No encryption support for xfs
generic/596	[not run] accton utility required, skipped this test
generic/597 23s ...  2s
generic/598 1s ...  1s
generic/599 1s ...  1s
generic/600	- output mismatch (see /home/test/git/xfstests/results//generic/600.out.bad)
    --- tests/generic/600.out	2021-02-28 21:47:48.622581352 -0600
    +++ /home/test/git/xfstests/results//generic/600.out.bad	2021-04-12 00:03:10.805194828 -0500
    __ -1,2 +1,3 __
     QA output created by 600
     Silence is golden
    +set grace to 1618203890 but got grace 1618203788
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/generic/600.out /home/test/git/xfstests/results//generic/600.out.bad'  to see the entire diff)
generic/601	[not run] xfs_quota does not support individual grace extension
generic/602	[not run] No encryption support for xfs
generic/603 61s ...  56s
generic/604 2s ...  2s
generic/605	[not run] mount /dev/sdb2 with dax=always failed
generic/606	[not run] mount /dev/sdb2 with dax=always failed
generic/607 1s ...  1s
generic/608	[not run] mount /dev/sdb2 with dax=always failed
generic/609 0s ...  1s
generic/610 4s ...  5s
generic/611 1s ...  1s
generic/612 1s ...  1s
generic/613	[not run] No encryption support for xfs
generic/614 1s ...  1s
generic/615 26s ...  24s
generic/616 62s ...  63s
generic/617 12s ...  12s
generic/618	[not run] test requires XFS bug_on_assert to be off, turn it off to run the test
generic/619 14s ...  14s
generic/620 2s ...  2s
generic/621	[not run] No encryption support for xfs
generic/622 23s ...  23s
shared/002 13s ...  12s
shared/032 54s ...  57s
shared/298 12s ...  12s
xfs/001 2s ...  2s
xfs/002 1s ...  1s
xfs/003 4s ...  5s
xfs/004 1s ...  0s
xfs/005 1s ...  1s
xfs/006 2s ...  3s
xfs/007 1s ...  1s
xfs/008 1s ...  1s
xfs/009 1s ...  1s
xfs/010 2s ...  2s
xfs/011 18s ...  17s
xfs/012 1s ...  1s
xfs/013 129s ...  125s
xfs/014 3s ...  2s
xfs/015 3s ...  3s
xfs/016 32s ...  32s
xfs/017 3s ...  3s
xfs/018	- output mismatch (see /home/test/git/xfstests/results//xfs/018.out.bad)
    --- tests/xfs/018.out	2021-02-28 21:47:48.634580518 -0600
    +++ /home/test/git/xfstests/results//xfs/018.out.bad	2021-04-12 00:11:44.651612557 -0500
    __ -1,17 +1,9 __
     QA output created by 018
     *** init FS
    -*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
    -*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
    -*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
    -*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
    -*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/018.out /home/test/git/xfstests/results//xfs/018.out.bad'  to see the entire diff)
xfs/019 1s ...  1s
xfs/020 1s ...  1s
xfs/021 0s ...  1s
xfs/022	[not run] xfsdump not found
xfs/023	[not run] xfsdump not found
xfs/024	[not run] xfsdump not found
xfs/025	[not run] xfsdump not found
xfs/026	[not run] xfsdump not found
xfs/027	[not run] xfsdump not found
xfs/028	[not run] xfsdump not found
xfs/029 0s ...  1s
xfs/030	- output mismatch (see /home/test/git/xfstests/results//xfs/030.out.bad)
    --- tests/xfs/030.out	2021-02-28 21:47:48.634580518 -0600
    +++ /home/test/git/xfstests/results//xfs/030.out.bad	2021-04-12 00:11:53.808251452 -0500
    __ -105,7 +105,6 __
     Phase 2 - using <TYPEOF> log
             - zero log...
             - scan filesystem freespace and inode maps...
    -bad agbno AGBNO in agfl, agno 0
             - found root inode chunk
     Phase 3 - for each AG...
             - scan and clear agi unlinked lists...
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/030.out /home/test/git/xfstests/results//xfs/030.out.bad'  to see the entire diff)
xfs/031 3s ...  4s
xfs/032 4s ...  5s
xfs/033 3s ...  2s
xfs/034 1s ...  0s
xfs/035	[not run] xfsdump not found
xfs/036	[not run] xfsdump not found
xfs/037	[not run] xfsdump not found
xfs/038	[not run] xfsdump not found
xfs/039	[not run] xfsdump not found
xfs/040	[not run] Can't run libxfs-diff without KWORKAREA set
xfs/041 12s ...  12s
xfs/042 13s ...  14s
xfs/043	[not run] xfsdump not found
xfs/044	[not run] This test requires a valid $SCRATCH_LOGDEV
xfs/045 1s ...  1s
xfs/046	[not run] xfsdump not found
xfs/047	[not run] xfsdump not found
xfs/048 0s ...  1s
xfs/049 2s ...  2s
xfs/050 4s ...  4s
xfs/051 17s ...  18s
xfs/052 1s ...  1s
xfs/053 0s ...  0s
xfs/054 1s ...  1s
xfs/055	[not run] xfsdump not found
xfs/056	[not run] xfsdump not found
xfs/057 17s ...  17s
xfs/058 1s ...  1s
xfs/059	[not run] xfsdump not found
xfs/060	[not run] xfsdump not found
xfs/061	[not run] xfsdump not found
xfs/062 4s ...  4s
xfs/063	[not run] xfsdump not found
xfs/064	[not run] xfsdump not found
xfs/065	[not run] xfsdump not found
xfs/066	[not run] xfsdump not found
xfs/067 0s ...  1s
xfs/068	[not run] xfsdump not found
xfs/069 1s ...  2s
xfs/070 1s ...  1s
xfs/071 1s ...  1s
xfs/072 1s ...  1s
xfs/073	- output mismatch (see /home/test/git/xfstests/results//xfs/073.out.bad)
    --- tests/xfs/073.out	2021-02-28 21:47:48.638580241 -0600
    +++ /home/test/git/xfstests/results//xfs/073.out.bad	2021-04-12 00:13:43.063547248 -0500
    __ -14,6 +14,14 __
     comparing new image files to old
     comparing new image directories to old
     comparing new image geometry to old
    +--- /tmp/2751531.geometry1	2021-04-12 00:13:38.127229711 -0500
    ++++ /tmp/2751531.geometry2	2021-04-12 00:13:38.135230226 -0500
    +__ -1,4 +1,4 __
    +-meta-data=<DEVIMAGE> isize=512 agcount=2, agsize=5248 blks
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/073.out /home/test/git/xfstests/results//xfs/073.out.bad'  to see the entire diff)
xfs/074 3s ...  2s
xfs/075 0s ...  1s
xfs/076 34s ...  34s
xfs/077 3s ...  3s
xfs/078 5s ...  4s
xfs/079 12s ...  12s
xfs/080 2s ...  2s
xfs/081	[failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//xfs/081.out.bad)
    --- tests/xfs/081.out	2021-02-28 21:47:48.638580241 -0600
    +++ /home/test/git/xfstests/results//xfs/081.out.bad	2021-04-12 00:14:42.615297160 -0500
    __ -1,4 +1,10 __
     QA output created by 081
     *** init FS
    -*** compare logprint: 081.ugquota.trans_inode with 081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
    +
    +*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=1 -l version=1 ***
    +
    +*** compare logprint: 081.ugquota.trans_inode with /home/test/git/xfstests/results//xfs/081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/081.out /home/test/git/xfstests/results//xfs/081.out.bad'  to see the entire diff)
xfs/082	- output mismatch (see /home/test/git/xfstests/results//xfs/082.out.bad)
    --- tests/xfs/082.out	2021-02-28 21:47:48.638580241 -0600
    +++ /home/test/git/xfstests/results//xfs/082.out.bad	2021-04-12 00:14:44.655423093 -0500
    __ -1,39 +1,11 __
     QA output created by 082
     *** init FS
     --- mkfs=version=2, mnt=logbsize=32k, sync=sync ---
    -*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.sync.filtered
    -*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.sync.filtered
    ---- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=sync ---
    -*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=4096.sync.filtered
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/082.out /home/test/git/xfstests/results//xfs/082.out.bad'  to see the entire diff)
xfs/083 394s ...  382s
xfs/084 60s ...  62s
xfs/085 3s ...  3s
xfs/086 4s ...  3s
xfs/087 3s ...  3s
xfs/088 3s ...  4s
xfs/089 4s ...  4s
xfs/090	[not run] External volumes not in use, skipped this test
xfs/091 3s ...  3s
xfs/092 1s ...  1s
xfs/093 3s ...  4s
xfs/094	[not run] External volumes not in use, skipped this test
xfs/095 1s ...  1s
xfs/096	[not run] Requires older mkfs without strict input checks: the last supported version of xfsprogs is 4.5.
xfs/097 3s ...  3s
xfs/098	[not run] test requires XFS bug_on_assert to be off, turn it off to run the test
xfs/099 1s ...  1s
xfs/100 3s ...  2s
xfs/101 2s ...  3s
xfs/102 8s ...  7s
xfs/103 1s ...  0s
xfs/104 13s ...  12s
xfs/105 7s ...  7s
xfs/106 17s ...  16s
xfs/107	- output mismatch (see /home/test/git/xfstests/results//xfs/107.out.bad)
    --- tests/xfs/107.out	2021-02-28 21:47:48.638580241 -0600
    +++ /home/test/git/xfstests/results//xfs/107.out.bad	2021-04-12 00:23:49.084870953 -0500
    __ -9,6 +9,32 __
     ### populate filesystem
     ### initial report
     [SCR_DEV] ([SCR_MNT]) Project:
    +   96532    #0      
    +    5004    #3      
    +    4356    #1      
    +    3876    #2      
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/107.out /home/test/git/xfstests/results//xfs/107.out.bad'  to see the entire diff)
xfs/108 1s ...  1s
xfs/109 21s ...  24s
xfs/110 3s ...  3s
xfs/111 4s ...  4s
xfs/112 7s ...  6s
xfs/113 44s ...  47s
xfs/114	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/115	[not run] test requires XFS bug_on_assert to be off, turn it off to run the test
xfs/116 1s ...  1s
xfs/117 4s ...  3s
xfs/118 10s ...  9s
xfs/119 3s ...  3s
xfs/120 3s ...  3s
xfs/121 6s ...  6s
xfs/122	[not run] indent utility required, skipped this test
xfs/123 2s ... [failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//xfs/123.out.bad)
    --- tests/xfs/123.out	2021-02-28 21:47:48.642579963 -0600
    +++ /home/test/git/xfstests/results//xfs/123.out.bad	2021-04-12 00:25:41.274261417 -0500
    __ -3,9 +3,7 __
     + mount fs image
     + make some files
     file contents: moo
    +umount: /mnt/scratch: target is busy.
     + check fs
    -+ corrupt image
    -+ mount image
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/123.out /home/test/git/xfstests/results//xfs/123.out.bad'  to see the entire diff)
xfs/124 2s ...  1s
xfs/125 4s ...  4s
xfs/126 4s ...  3s
xfs/127 2s ...  2s
xfs/128 8s ...  9s
xfs/129 4s ...  3s
xfs/130 2s ...  1s
xfs/131	[not run] External volumes not in use, skipped this test
xfs/132 0s ...  1s
xfs/133 1s ...  1s
xfs/134 1s ...  0s
xfs/135 2s ...  2s
xfs/136	- output mismatch (see /home/test/git/xfstests/results//xfs/136.out.bad)
    --- tests/xfs/136.out	2021-02-28 21:47:48.642579963 -0600
    +++ /home/test/git/xfstests/results//xfs/136.out.bad	2021-04-12 00:48:25.823406767 -0500
    __ -1,5 +1,5 __
     QA output created by 136
    -inum=67
    +inum=131
     core.format = 2 (extents)
     core.size = 0
     core.extsize = 0
    __ -7,6 +7,7 __
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/136.out /home/test/git/xfstests/results//xfs/136.out.bad'  to see the entire diff)
xfs/137 4s ...  4s
xfs/138 3s ...  3s
xfs/139 6s ...  5s
xfs/140 47s ...  45s
xfs/141 9s ...  12s
xfs/142	[not run] Assuming DMAPI modules are not loaded
xfs/143	[not run] Assuming DMAPI modules are not loaded
xfs/144	[not run] Assuming DMAPI modules are not loaded
xfs/145	[not run] Assuming DMAPI modules are not loaded
xfs/146	[not run] Assuming DMAPI modules are not loaded
xfs/147	[not run] Assuming DMAPI modules are not loaded
xfs/148 3s ...  1s
xfs/149 2s ...  1s
xfs/150	[not run] Assuming DMAPI modules are not loaded
xfs/151	[not run] Assuming DMAPI modules are not loaded
xfs/152	[not run] Assuming DMAPI modules are not loaded
xfs/153	[not run] Assuming DMAPI modules are not loaded
xfs/154	[not run] Assuming DMAPI modules are not loaded
xfs/155	[not run] Assuming DMAPI modules are not loaded
xfs/156	[not run] Assuming DMAPI modules are not loaded
xfs/157	[not run] Assuming DMAPI modules are not loaded
xfs/158	[not run] Assuming DMAPI modules are not loaded
xfs/159	[not run] Assuming DMAPI modules are not loaded
xfs/160	[not run] Assuming DMAPI modules are not loaded
xfs/161	[not run] Assuming DMAPI modules are not loaded
xfs/162	[not run] Assuming DMAPI modules are not loaded
xfs/163	[not run] Assuming DMAPI modules are not loaded
xfs/164 1s ...  1s
xfs/165 1s ...  1s
xfs/166 1s ...  0s
xfs/167 62s ...  61s
xfs/168	[not run] Assuming DMAPI modules are not loaded
xfs/169 15s ...  16s
xfs/170 3s ...  2s
xfs/171 17s ...  18s
xfs/172	[failed, exit status 1]- output mismatch (see /home/test/git/xfstests/results//xfs/172.out.bad)
    --- tests/xfs/172.out	2021-02-28 21:47:48.642579963 -0600
    +++ /home/test/git/xfstests/results//xfs/172.out.bad	2021-04-12 00:51:27.328872669 -0500
    __ -3,9 +3,5 __
     # streaming
     # sync AGs...
     # checking stream AGs...
    -+ expected failure, matching AGs
    -# testing 64 16 20 10 1 0 1 ....
    -# streaming
    -# sync AGs...
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/172.out /home/test/git/xfstests/results//xfs/172.out.bad'  to see the entire diff)
xfs/173 8s ...  8s
xfs/174 4s ...  3s
xfs/175	[not run] Assuming DMAPI modules are not loaded
xfs/176	[not run] Assuming DMAPI modules are not loaded
xfs/177	[not run] Assuming DMAPI modules are not loaded
xfs/178 1s ...  1s
xfs/179 1s ...  1s
xfs/180 1s ...  1s
xfs/181 11s ...  11s
xfs/182 2s ...  2s
xfs/183 3s ...  3s
xfs/184 2s ...  2s
xfs/185	[not run] Assuming DMAPI modules are not loaded
xfs/186	[not run] attr v1 not supported on /dev/sdb2
xfs/187	[not run] attr v1 not supported on /dev/sdb2
xfs/188 10s ...  9s
xfs/189	[not run] noattr2 mount option not supported on /dev/sdb2
xfs/190 1s ...  1s
xfs/191-input-validation 6s ...  4s
xfs/192 2s ...  2s
xfs/193 2s ...  1s
xfs/194 1s ...  1s
xfs/195	[not run] xfsdump utility required, skipped this test
xfs/196 1s ...  1s
xfs/197	[not run] This test is only valid on 32 bit machines
xfs/198 2s ...  1s
xfs/199 1s ...  1s
xfs/200 2s ...  2s
xfs/201 1s ...  1s
xfs/202 1s ...  1s
xfs/203 2s ...  1s
xfs/204 2s ...  2s
xfs/205 2s ...  2s
xfs/206 2s ...  1s
xfs/207 2s ...  1s
xfs/208 2s ...  2s
xfs/209 1s ...  1s
xfs/210 2s ...  1s
xfs/211 217s ...  228s
xfs/212 2s ...  1s
xfs/213 3s ...  4s
xfs/214 6s ...  3s
xfs/215 1s ...  2s
xfs/216 2s ...  2s
xfs/217 1s ...  1s
xfs/218 2s ...  2s
xfs/219 2s ...  1s
xfs/220 1s ...  1s
xfs/221 2s ...  2s
xfs/222 3s ...  1s
xfs/223 2s ...  2s
xfs/224 2s ...  1s
xfs/225 2s ...  2s
xfs/226 1s ...  1s
xfs/227 299s ...  294s
xfs/228 2s ...  1s
xfs/229 9s ...  8s
xfs/230 2s ...  2s
xfs/231 4s ...  5s
xfs/232 4s ...  4s
xfs/233	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/234	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/235	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/236	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/237 2s ...  2s
xfs/238 2s ...  1s
xfs/239 1s ...  2s
xfs/240 3s ...  2s
xfs/241 1s ...  2s
xfs/242 2s ...  1s
xfs/243 1s ...  1s
xfs/244	[not run] 16 bit project IDs not supported on /dev/sdb2
xfs/245 1s ...  1s
xfs/246 0s ...  1s
xfs/247 1s ...  0s
xfs/248 2s ...  2s
xfs/249 1s ...  1s
xfs/250 8s ...  7s
xfs/251 2s ...  2s
xfs/252 2s ...  2s
xfs/253 2s ...  2s
xfs/254 1s ...  1s
xfs/255 2s ...  2s
xfs/256 1s ...  1s
xfs/257 2s ...  2s
xfs/258 2s ...  2s
xfs/259 3s ...  3s
xfs/260 1s ...  1s
xfs/261 1s ...  0s
xfs/262	- output mismatch (see /home/test/git/xfstests/results//xfs/262.out.bad)
    --- tests/xfs/262.out	2021-02-28 21:47:48.650579408 -0600
    +++ /home/test/git/xfstests/results//xfs/262.out.bad	2021-04-12 01:03:02.923150108 -0500
    __ -1,3 +1,5 __
     QA output created by 262
     Format and populate
     Force online repairs
    +Error: /mnt/scratch: Kernel metadata scrubbing facility is not available. (phase1.c line 147)
    +/mnt/scratch: operational errors found: 1
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/262.out /home/test/git/xfstests/results//xfs/262.out.bad'  to see the entire diff)
xfs/263 1s ...  2s
xfs/264 6s ...  5s
xfs/265 8s ...  7s
xfs/266	[not run] xfsdump not found
xfs/267	[not run] xfsdump not found
xfs/268	[not run] xfsdump not found
xfs/269 1s ...  1s
xfs/270 1s ...  1s
xfs/271	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/272	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/273 4s ...  116s
xfs/274	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/275	[not run] This test requires a valid $SCRATCH_LOGDEV
xfs/276	[not run] External volumes not in use, skipped this test
xfs/277	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/278 1s ...  1s
xfs/279 10s ...  9s
xfs/280 1s ...  2s
xfs/281	[not run] xfsdump not found
xfs/282	[not run] xfsdump not found
xfs/283	[not run] xfsdump not found
xfs/284 1s ...  1s
xfs/285	- output mismatch (see /home/test/git/xfstests/results//xfs/285.out.bad)
    --- tests/xfs/285.out	2021-02-28 21:47:48.650579408 -0600
    +++ /home/test/git/xfstests/results//xfs/285.out.bad	2021-04-12 01:06:37.689415191 -0500
    __ -1,4 +1,6 __
     QA output created by 285
     Format and populate
    +Error: /mnt/scratch: Kernel metadata scrubbing facility is not available. (phase1.c line 147)
    +/mnt/scratch: operational errors found: 1
     Concurrent scrub
     Test done
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/285.out /home/test/git/xfstests/results//xfs/285.out.bad'  to see the entire diff)
xfs/286	- output mismatch (see /home/test/git/xfstests/results//xfs/286.out.bad)
    --- tests/xfs/286.out	2021-02-28 21:47:48.650579408 -0600
    +++ /home/test/git/xfstests/results//xfs/286.out.bad	2021-04-12 01:07:41.784464380 -0500
    __ -1,4 +1,132 __
     QA output created by 286
     Format and populate
    +Error: /mnt/scratch: Kernel metadata scrubbing facility is not available. (phase1.c line 147)
    +/mnt/scratch: operational errors found: 1
     Concurrent repair
    +Error: /mnt/scratch: Kernel metadata scrubbing facility is not available. (phase1.c line 147)
    +/mnt/scratch: operational errors found: 1
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/286.out /home/test/git/xfstests/results//xfs/286.out.bad'  to see the entire diff)
xfs/287	[not run] xfsdump not found
xfs/288 0s ...  1s
xfs/289 1s ...  1s
xfs/290 0s ...  1s
xfs/291 45s ...  49s
xfs/292 1s ...  1s
xfs/293 0s ...  0s
xfs/294 17s ...  16s
xfs/295 8s ...  10s
xfs/296	[not run] xfsdump not found
xfs/297 38s ...  43s
xfs/298 3s ...  3s
xfs/299 4s ...  4s
xfs/300	[not run] SELinux not enabled
xfs/301	[not run] xfsdump not found
xfs/302	[not run] xfsdump not found
xfs/303 1s ...  0s
xfs/304 1s ... - output mismatch (see /home/test/git/xfstests/results//xfs/304.out.bad)
    --- tests/xfs/304.out	2021-02-28 21:47:48.650579408 -0600
    +++ /home/test/git/xfstests/results//xfs/304.out.bad	2021-04-12 01:09:55.442806556 -0500
    __ -3,5 +3,6 __
     *** umount
     *** turn off project quotas
     *** umount
    +umount: /mnt/scratch: target is busy.
     *** turn off group/project quotas
     *** umount
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/304.out /home/test/git/xfstests/results//xfs/304.out.bad'  to see the entire diff)
xfs/305 65s ...  65s
xfs/306 12s ...  12s
xfs/307 2s ...  2s
xfs/308 1s ...  1s
xfs/309 8s ...  8s
xfs/310	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/311 21s ...  22s
xfs/312 2s ...  1s
xfs/313 1s ...  1s
xfs/314	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/315 1s ...  1s
xfs/316 1s ...  1s
xfs/317	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/318 0s ...  1s
xfs/319 2s ...  1s
xfs/320 1s ...  1s
xfs/321 1s ...  1s
xfs/322	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/323 1s ...  1s
xfs/324 1s ...  1s
xfs/325 1s ...  1s
xfs/326 2s ...  1s
xfs/327 1s ...  2s
xfs/328 30s ...  28s
xfs/329	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/330 1s ...  1s
xfs/331	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/332	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/333	[not run] rmapbt not supported by scratch filesystem type: xfs
xfs/334	[not run] External volumes not in use, skipped this test
xfs/335	[not run] External volumes not in use, skipped this test
xfs/336	[not run] External volumes not in use, skipped this test
xfs/337	[not run] External volumes not in use, skipped this test
xfs/338	[not run] External volumes not in use, skipped this test
xfs/339	[not run] External volumes not in use, skipped this test
xfs/340	[not run] External volumes not in use, skipped this test
xfs/341	[not run] External volumes not in use, skipped this test
xfs/342	[not run] External volumes not in use, skipped this test
xfs/343	[not run] External volumes not in use, skipped this test
xfs/344 1s ...  1s
xfs/345 2s ...  2s
xfs/346 5s ...  6s
xfs/347	- output mismatch (see /home/test/git/xfstests/results//xfs/347.out.bad)
    --- tests/xfs/347.out	2021-02-28 21:47:48.654579130 -0600
    +++ /home/test/git/xfstests/results//xfs/347.out.bad	2021-04-12 01:12:50.420814520 -0500
    __ -5,6 +5,10 __
     2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-347/file1
     2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-347/file2
     CoW and unmount
    +umount: /mnt/scratch: target is busy.
    +mount: /mnt/scratch: /dev/sdb2 already mounted on /mnt/scratch.
    +cycle mount failed
    +(see /home/test/git/xfstests/results//xfs/347.full for details)
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/347.out /home/test/git/xfstests/results//xfs/347.out.bad'  to see the entire diff)
xfs/348 7s ...  7s
xfs/349	- output mismatch (see /home/test/git/xfstests/results//xfs/349.out.bad)
    --- tests/xfs/349.out	2021-02-28 21:47:48.654579130 -0600
    +++ /home/test/git/xfstests/results//xfs/349.out.bad	2021-04-12 01:13:00.413385104 -0500
    __ -1,3 +1,5 __
     QA output created by 349
     Format and populate
     Scrub
    +Error: /mnt/scratch: Kernel metadata scrubbing facility is not available. (phase1.c line 147)
    +/mnt/scratch: operational errors found: 1
    ...
    (Run 'diff -u /home/test/git/xfstests/tests/xfs/349.out /home/test/git/xfstests/results//xfs/349.out.bad'  to see the entire diff)
xfs/350	

Other tests might need to be run in order to verify everything is working
as expected. For such tests, the intervention of the maintainers might be
needed.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Build-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/6070a809.7QaU2ofU9h9VwFeh%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v4:
 - Fix size for kmem_cache_create() in fs/xfs/xfs_super.c:xfs_init_zones().
 - Update changelog text with test results on Linux 5.12-rc6.

Changes in v3:
 - Add multiple inline functions as wrappers for struct_size(), as
   per Darrick's request.
 - Use type size_t instead of uint for a couple of objects.

Changes in v2:
 - Use struct_size() helper in more places.
 - Update changelog text with testing results on Linux 5.12.0-rc2.
 - Fix issue with use of struct_size() with the right struct object.
 - Use flex_array_size() helper.

 fs/xfs/libxfs/xfs_log_format.h |  12 ++--
 fs/xfs/xfs_extfree_item.c      | 102 +++++++++++++++++++++++----------
 fs/xfs/xfs_ondisk.h            |   8 +--
 fs/xfs/xfs_super.c             |  14 ++---
 4 files changed, 90 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8bd00da6d2a4..9934a465b441 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -574,7 +574,7 @@ typedef struct xfs_efi_log_format {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_t		efi_extents[1];	/* array of extents to free */
+	xfs_extent_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
 typedef struct xfs_efi_log_format_32 {
@@ -582,7 +582,7 @@ typedef struct xfs_efi_log_format_32 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
+	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
 typedef struct xfs_efi_log_format_64 {
@@ -590,7 +590,7 @@ typedef struct xfs_efi_log_format_64 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
+	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
 /*
@@ -603,7 +603,7 @@ typedef struct xfs_efd_log_format {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_t		efd_extents[1];	/* array of extents freed */
+	xfs_extent_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
 typedef struct xfs_efd_log_format_32 {
@@ -611,7 +611,7 @@ typedef struct xfs_efd_log_format_32 {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
+	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
 typedef struct xfs_efd_log_format_64 {
@@ -619,7 +619,7 @@ typedef struct xfs_efd_log_format_64 {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
+	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 93223ebb3372..17b3ff8ce05f 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -73,8 +73,8 @@ static inline int
 xfs_efi_item_sizeof(
 	struct xfs_efi_log_item *efip)
 {
-	return sizeof(struct xfs_efi_log_format) +
-	       (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
+	return struct_size(&efip->efi_format, efi_extents,
+			   efip->efi_format.efi_nextents);
 }
 
 STATIC void
@@ -153,17 +153,14 @@ xfs_efi_init(
 
 {
 	struct xfs_efi_log_item	*efip;
-	uint			size;
 
 	ASSERT(nextents > 0);
-	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(struct xfs_efi_log_item) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, 0);
-	} else {
+	if (nextents > XFS_EFI_MAX_FAST_EXTENTS)
+		efip = kmem_zalloc(struct_size(efip, efi_format.efi_extents,
+					       nextents), 0);
+	else
 		efip = kmem_cache_zalloc(xfs_efi_zone,
 					 GFP_KERNEL | __GFP_NOFAIL);
-	}
 
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
 	efip->efi_format.efi_nextents = nextents;
@@ -174,6 +171,36 @@ xfs_efi_init(
 	return efip;
 }
 
+/*
+ * Calculates the size of structure xfs_efi_log_format followed by an
+ * array of n number of efi_extents elements.
+ */
+static inline size_t
+sizeof_efi_log_format(size_t n)
+{
+	return struct_size((struct xfs_efi_log_format *)0, efi_extents, n);
+}
+
+/*
+ * Calculates the size of structure xfs_efi_log_format_32 followed by an
+ * array of n number of efi_extents elements.
+ */
+static inline size_t
+sizeof_efi_log_format_32(size_t n)
+{
+	return struct_size((struct xfs_efi_log_format_32 *)0, efi_extents, n);
+}
+
+/*
+ * Calculates the size of structure xfs_efi_log_format_64 followed by an
+ * array of n number of efi_extents elements.
+ */
+static inline size_t
+sizeof_efi_log_format_64(size_t n)
+{
+	return struct_size((struct xfs_efi_log_format_64 *)0, efi_extents, n);
+}
+
 /*
  * Copy an EFI format buffer from the given buf, and into the destination
  * EFI format structure.
@@ -186,12 +213,9 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 {
 	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
 	uint i;
-	uint len = sizeof(xfs_efi_log_format_t) + 
-		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_t);  
-	uint len32 = sizeof(xfs_efi_log_format_32_t) + 
-		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_32_t);  
-	uint len64 = sizeof(xfs_efi_log_format_64_t) + 
-		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_64_t);  
+	size_t len = sizeof_efi_log_format(src_efi_fmt->efi_nextents);
+	size_t len32 = sizeof_efi_log_format_32(src_efi_fmt->efi_nextents);
+	size_t len64 = sizeof_efi_log_format_64(src_efi_fmt->efi_nextents);
 
 	if (buf->i_len == len) {
 		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
@@ -253,8 +277,8 @@ static inline int
 xfs_efd_item_sizeof(
 	struct xfs_efd_log_item *efdp)
 {
-	return sizeof(xfs_efd_log_format_t) +
-	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
+	return struct_size(&efdp->efd_format, efd_extents,
+			   efdp->efd_format.efd_nextents);
 }
 
 STATIC void
@@ -328,14 +352,12 @@ xfs_trans_get_efd(
 
 	ASSERT(nextents > 0);
 
-	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
-				(nextents - 1) * sizeof(struct xfs_extent),
-				0);
-	} else {
+	if (nextents > XFS_EFD_MAX_FAST_EXTENTS)
+		efdp = kmem_zalloc(struct_size(efdp, efd_format.efd_extents,
+					nextents), 0);
+	else
 		efdp = kmem_cache_zalloc(xfs_efd_zone,
 					GFP_KERNEL | __GFP_NOFAIL);
-	}
 
 	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
 			  &xfs_efd_item_ops);
@@ -666,11 +688,13 @@ xfs_efi_item_relog(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 	efdp->efd_next_extent = count;
-	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+	memcpy(efdp->efd_format.efd_extents, extp,
+	       flex_array_size(&efdp->efd_format, efd_extents, count));
 	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
 
 	efip = xfs_efi_init(tp->t_mountp, count);
-	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	memcpy(efip->efi_format.efi_extents, extp,
+	       flex_array_size(&efip->efi_format, efi_extents, count));
 	atomic_set(&efip->efi_next_extent, count);
 	xfs_trans_add_item(tp, &efip->efi_item);
 	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
@@ -729,6 +753,26 @@ const struct xlog_recover_item_ops xlog_efi_item_ops = {
 	.commit_pass2		= xlog_recover_efi_commit_pass2,
 };
 
+/*
+ * Calculates the size of structure xfs_efd_log_format_32 followed by an
+ * array of n number of efd_extents elements.
+ */
+static inline size_t
+sizeof_efd_log_format_32(size_t n)
+{
+	return struct_size((struct xfs_efd_log_format_32 *)0, efd_extents, n);
+}
+
+/*
+ * Calculates the size of structure xfs_efd_log_format_64 followed by an
+ * array of n number of efd_extents elements.
+ */
+static inline size_t
+sizeof_efd_log_format_64(size_t n)
+{
+	return struct_size((struct xfs_efd_log_format_64 *)0, efd_extents, n);
+}
+
 /*
  * This routine is called when an EFD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding EFI if it
@@ -746,10 +790,10 @@ xlog_recover_efd_commit_pass2(
 	struct xfs_efd_log_format	*efd_formatp;
 
 	efd_formatp = item->ri_buf[0].i_addr;
-	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
-		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
-	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
-		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
+	ASSERT(item->ri_buf[0].i_len ==
+			sizeof_efd_log_format_32(efd_formatp->efd_nextents) ||
+	       item->ri_buf[0].i_len ==
+			sizeof_efd_log_format_64(efd_formatp->efd_nextents));
 
 	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
 	return 0;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0aa87c210104..f58e0510385a 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -118,10 +118,10 @@ xfs_check_ondisk_structs(void)
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e5e0713bebcd..923145737110 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1937,17 +1937,17 @@ xfs_init_zones(void)
 		goto out_destroy_trans_zone;
 
 	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
-					(sizeof(struct xfs_efd_log_item) +
-					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
-					sizeof(struct xfs_extent)),
-					0, 0, NULL);
+					 struct_size((struct xfs_efd_log_item *)0,
+					 efd_format.efd_extents,
+					 XFS_EFD_MAX_FAST_EXTENTS),
+					 0, 0, NULL);
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;
 
 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
-					 (sizeof(struct xfs_efi_log_item) +
-					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
-					 sizeof(struct xfs_extent)),
+					 struct_size((struct xfs_efi_log_item *)0,
+					 efi_format.efi_extents,
+					 XFS_EFI_MAX_FAST_EXTENTS),
 					 0, 0, NULL);
 	if (!xfs_efi_zone)
 		goto out_destroy_efd_zone;
-- 
2.27.0

