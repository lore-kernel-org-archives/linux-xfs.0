Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C9267F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 16:37:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 218CA8F8037
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 14:37:51 -0700 (PDT)
Received: from mail-gg0-f170.google.com (mail-gg0-f170.google.com
	[209.85.161.170]) by cuda.sgi.com with ESMTP id
	WIw7fdckMXa4IJPn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 14:37:50 -0700 (PDT)
Received: by mail-gg0-f170.google.com with SMTP id s5so1811786ggc.15
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 14:37:49 -0700 (PDT)
Message-ID: <51A280A5.6000507@gmail.com>
Date: Sun, 26 May 2013 17:37:41 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 05/25/2013 07:15 PM, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Since h_chksum field has gone away, we should cleanup the related codes
> 
>     [CC]    loggen
> loggen.c: In function 'loggen_unmount':
> loggen.c:137:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> loggen.c: In function 'loggen_empty':
> loggen.c:205:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  src/loggen.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/src/loggen.c b/src/loggen.c
> index 4b55667..522c917 100644
> --- a/src/loggen.c
> +++ b/src/loggen.c
> @@ -134,7 +134,6 @@ loggen_unmount(int count)
>      head->h_cycle = cpu_to_be32(param_cycle);
>      head->h_version = cpu_to_be32(1);
>      head->h_len = cpu_to_be32(20);
> -    head->h_chksum = cpu_to_be32(0);
>      head->h_prev_block = cpu_to_be32(-1);
>      head->h_num_logops = cpu_to_be32(1);
>      head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
> @@ -202,7 +201,6 @@ loggen_empty(int count)
>                                                      sizeof(xfs_trans_header_t)+
>                                                      sizeof(xfs_buf_log_format_t)+
>                                                      sizeof(int));
> -    head->h_chksum         = cpu_to_be32(0);
>      head->h_prev_block     = cpu_to_be32(-1);
>      head->h_num_logops     = cpu_to_be32(5);
>      head->h_cycle_data[0]  = cpu_to_be32(0xb0c0d0d0);
> 

I've been taking a wild guess and changing "h_chksum" to "h_crc", just 
as a pure sysadmin hack to keep going.  Is there more than one correct 
answer on this issue?

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
