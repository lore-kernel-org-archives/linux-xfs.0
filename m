Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1B54E7F51
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 12:22:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0E2E8F804B
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 10:22:25 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id NCtyTGuyXSHQwzDh
	for <xfs@oss.sgi.com>; Fri, 07 Mar 2014 10:22:24 -0800 (PST)
Message-ID: <531A0E5B.108@fb.com>
Date: Fri, 7 Mar 2014 13:22:19 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add test for btrfs send issuing premature
	rmdir operations
References: <1392820352-8550-1-git-send-email-fdmanana@gmail.com>
	<1393242878-16039-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393242878-16039-1-git-send-email-fdmanana@gmail.com>
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

On 02/24/2014 06:54 AM, Filipe David Borba Manana wrote:
> Regression test for btrfs incremental send issue where a rmdir
> instruction is sent against an orphan directory inode which is not
> empty yet, causing btrfs receive to fail when it attempts to remove
> the directory.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
> Btrfs: fix send attempting to rmdir non-empty directories
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com> ---

Looks good to me,

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGg5bAAoJEANb+wAKly3BFtMQAMDITxFeFKRw5o5g88NUJT+n
/AQp584QUb+sBhJnyYVET98S47R4C9d7jAu8fUxUJd2FaZ0UPR+rl/LnpdYXy8oJ
29A2tvbSiOZGQp+kWlGpLqKmmEj/3R/0QZwTrB1jsxKwVsH+OGK1fazOwhkahloL
8R6xBtcvMzkBFEQ08T0dmodDaWKPp8dgztcScrVt+RGkePPVoKE9X4hwTwAl8muk
nPv9TvRULOs2emvxuTnEVqZfou0HcOTuKWXAOXN2peXBe324SjfQ0JmAMjtG1Ukw
nAs5wu8eII1k9/rjGLarNhpuSuMaM5tth0tIb2ebYwxwpYpY6o4eNN2RR6vWlCEz
vULou68VKdOG6/c6uO6cXuI8zOwScWuYyYFXFLTFpAhjdKwY1HaCwSanvnamdYy8
kNITDGkYSqs0Abj9wzQDcJcTrjpHDDe/3olb5LMJjrdTneMyDVXc+Ym+FbBhmQUX
d7vC+a7sRVWwN4xGoqxDgZZQLpGBEO60FhA5kIO9lgis2LdG8SXE0ch4sQuWZ8iC
S9Aw46dssmiY+d3BkugCOPW/7IlID/obLGUF+CWcWMkxSMbwaPn6RfNJmW+9k+rv
fkUVj+U75pBtnuwW3LxV7gUq8HwTz8G1fh+96o41yKXpayBQUoIA47AHCUZtP9Fi
RemqwFmZxhi7ztZYfni2
=8Kl8
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
