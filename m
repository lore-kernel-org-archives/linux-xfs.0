Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36C577F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 14:46:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E06D8F8035
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:46:46 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id AVhwUqBAzxgn4qWE
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:46:45 -0700 (PDT)
Message-ID: <531E1692.5010003@fb.com>
Date: Mon, 10 Mar 2014 15:46:26 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] xfstests/btrfs: add basic functional test for
	btrfs quota groups
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1394423051-17356-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394423051-17356-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/09/2014 11:44 PM, Wang Shilong wrote:
> Add missing test for btrfs quota groups feature,test idea is to
> create a parent qgroup that groups some subvolume groups, we try to
> write some data into every subvolume and then check if we exceed
> parent qgroup's limit size.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com> --- 
> v1->v2: switch into new helper _run_btrfs_util_prog() use
> 'XFS_IO_PROG' instead of 'dd'

Ran fine, looks reasonable

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHhaRAAoJEANb+wAKly3BQA8QALiXQci/aiNj70AZ353ATQBI
EseYkX9qmuNfYRfZW1FRCoUdXANCCENkovsxaOvZ2kQlhSG1I1kYzZu+GDA6d8Ah
LquR5XoHoSKP3My3y1tZnmkYcND/Uq2RXxMlPZA5IvulzDDvv3dE+JRn0fcq1Fhp
u3IYyFEt4xtv86uLMdJk2fi1bwhoepdMO3WUnYWnRgcVzI+wlLz5pCryxnn9MZau
0MYwce5nmc3mqlNeMHnfARixI91X5W676kymbKE0+7zEwdXruqckS/MMg4qdESUV
NLkEDkFzE1RM37Yg6VRB+V9R3bP4o5P1lm4evXhAA+fmneqsVWgOSJ+fKYPzsYFr
cJF8V3WSkFlRWQhdsZIb/bSBuZHe2hr9kEshX4uqlX74qEzrWMrN+NeixzpVC/1f
k4yj+9RqBXNW6QfBQW7rj40JUVCb6yltDjpaHbUagQwN1wAcOBDlKYb3KOjJdU1u
wGS0ZRRRx4PJkgFviJoNuv2ZeSaPnUcVvGe3XdbNC6Lh2orzHwopcvEPFVHF5hI6
NgUlxeVhbSXKrAI07V467wZ0voQkpVl/srkLdlZx/4lPdgcTA3DSNv5NbBdPRWmD
g6atdMQkSN4f+NxJDVSU7Kr9CBczQm7fms794DljX0Q1vMBBB9XO+pxlnnIaaaSf
5a8HFdn6+pvKxTU+ETUJ
=SHWF
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
