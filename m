Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A39C27F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 14:56:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B72BAC001
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:56:32 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id N32TeyBzE4ZKLtSY
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:56:31 -0700 (PDT)
Message-ID: <531E18E9.5050206@fb.com>
Date: Mon, 10 Mar 2014 15:56:25 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add test btrfs/042 for btrfs incremental send
References: <1392940976-1790-1-git-send-email-fdmanana@gmail.com>
	<1393242925-16087-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393242925-16087-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/24/2014 06:55 AM, Filipe David Borba Manana wrote:
> Regression test for a btrfs incremental send issue where invalid
> paths for utimes, chown and chmod operations were sent to the send
> stream, causing btrfs receive to fail.
> 
> If a directory had a move/rename operation delayed, and none of its
> parent directories, except for the immediate one, had delayed
> move/rename operations, after processing the directory's
> references, the incremental send code would issue invalid paths for
> utimes, chown and chmod operations.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
> Btrfs: fix send issuing outdated paths for utimes, chown and chmod
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com> ---
> 

Worked as expected, thanks

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHhjpAAoJEANb+wAKly3Bh9gQANDHrCRfOb0Xwp0EKFreXyL0
6CysWgSsZqUusillUPMNzwu/fY8fKH6ZWU2Q3f1ysx3KH+2cLZqEqdVaG7S5Q6rA
BWpSTwsEDrzshKFOVLCJfVeZdMglgcYkKFyHC+0mym+JG81ksQl9tiSfTo5vXQV4
PuZ5zg9b9FWBCquEnQ7vpyxyVA/h9hc8YDyuKadeN60fYhzxdHIR/3FPqrh+UeCc
XSbMRupNdPCtMVc/mADMfOhiUVQTpsSz+iL3+lVG7lbVp8hAio6DspFETvKyzcUV
S8l7LkknMX1ylFRV/wc5RBVU1MrFih3qn1GOmT/rAMipXM2q5n7CQ4NaVBbYaMRO
AuyPhygQqH1k3FnMBQGIai37StAmhSPlYMDwWSETP3Uw6V0kENWLyPG02U6uM2cI
wBWg86/EUNmt5zC9YTbehuD12Jyb3rv3JyhzNeoNhyJv5o1a7bKvV8Uc1NcVu1ng
fGSO+RWlhqxyoXCwSa5Zor3j3nYUN8pxDk9M/wppTb211oKnYC2xAcGThly4eU7L
rwRrx7f7lG6Ep6R5Y9NAfEqHQftjML3R4Tc+RJ/MgpON4RDEaFX5l2tWOKior/Ss
yAg5vAVejFAbiVs8ueYTN+k5GAiFu7Zsrx/7uohVzMyI2qrxj5ZkxbFYY/fffLZV
LcmEQsMTKiGmV3fXJzyj
=vgY8
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
