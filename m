Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDCDF7F3F
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 10:25:26 -0500 (CDT)
Message-ID: <51A4CC99.2040901@sgi.com>
Date: Tue, 28 May 2013 10:26:17 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: cleanup the codes related to h_chksum
References: <1369523732-10649-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1369523732-10649-1-git-send-email-zwu.kernel@gmail.com>
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
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 05/25/2013 06:15 PM, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
>    Since h_chksum field has gone away, we should cleanup the related codes
>
>      [CC]    loggen
> loggen.c: In function 'loggen_unmount':
> loggen.c:137:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> loggen.c: In function 'loggen_empty':
> loggen.c:205:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Thanks for the patch, it has been committed:

commit f761cd9a6aa9b44be7f3056f01c419edf1356789
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Tue May 28 08:31:52 2013 -0500

     xfstests: cleanup the codes related to h_chksum


--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
