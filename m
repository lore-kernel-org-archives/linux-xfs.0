Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9109029DF9
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 23:41:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10FA3AC001
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 21:41:20 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Cylc9vhgqZvZOlRu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 21:41:15 -0800 (PST)
Message-ID: <5289A89E.2050105@oracle.com>
Date: Mon, 18 Nov 2013 13:41:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: introduce list_get_first/last (Was: [PATCH 3/6] gfs2: simplify
	current_tail() via list_last_entry_or_null())
References: <5285A3F4.4040000@oracle.com> <20131115163957.GA28467@redhat.com>
	<20131115171259.GA10687@redhat.com>
In-Reply-To: <20131115171259.GA10687@redhat.com>
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
To: Oleg Nesterov <oleg@redhat.com>
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org

Hi Oleg,

Sorry for my late response!

On 11/16/2013 01:12 AM, Oleg Nesterov wrote:

> On 11/15, Oleg Nesterov wrote:
>>
>> But probably list_last_entry() makes sense in the "else" branch,
>> athough this is minor.
>>
>>
>> Off-topic. Not sure this really makes sense, but I was thinking about
>>
>> 	list_get_first(pos, head, member)	\
>> 		((pos) = list_first_entry(head, typeof(*pos), member))
>>
>> and list_get_first() last of course. The obvious advantage is that
>> compared to
>>
>> 	tr = list_last_entry(sdp->sd_ail1_list, struct gfs2_trans, tr_list);
>>
>> above you do not need to type "struct gfs2_trans",
>>
>> 	list_get_last(tr, sdp->sd_ail1_list, tr_list);
>>
>> looks a bit better.
> 
> And list.h can use it too.
> 
> So how about the patch below? I can't decide whether it cleanups or
> uglfies the code, I do not trust my taste ;) But to me it looks a
> bit better this way.

I personally think this is better for GFS2 case if I understood correctly,
and it can make the existing list helper a bit neat per my taste :)

The current list_first_entry() works fine consider a common pattern below:
while (!list_empty(ptr)) {
	struct dummy *p = list_first_entry(ptr, struct dummy, member);

	....
}

But I'm not sure if we can find out more external use cases can get
benefits with list_get_first/last...

Thanks,
-Jeff

> 
> Oleg.
> --
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index ef95941..f52aba8 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -372,6 +372,12 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_last_entry(ptr, type, member) \
>  	list_entry((ptr)->prev, type, member)
>  
> +#define list_get_first(pos, head, member)	\
> +	((pos) = list_first_entry(head, typeof(*(pos)), member))
> +
> +#define list_get_last(pos, head, member)	\
> +	((pos) = list_last_entry(head, typeof(*(pos)), member))
> +
>  /**
>   * list_first_entry_or_null - get the first element from a list
>   * @ptr:	the list head to take the element from.
> @@ -443,7 +449,7 @@ static inline void list_splice_tail_init(struct list_head *list,
>   * @member:	the name of the list_struct within the struct.
>   */
>  #define list_for_each_entry(pos, head, member)				\
> -	for (pos = list_first_entry(head, typeof(*pos), member);	\
> +	for (list_get_first(pos, head, member);				\
>  	     &pos->member != (head);					\
>  	     pos = list_next_entry(pos, member))
>  
> @@ -454,7 +460,7 @@ static inline void list_splice_tail_init(struct list_head *list,
>   * @member:	the name of the list_struct within the struct.
>   */
>  #define list_for_each_entry_reverse(pos, head, member)			\
> -	for (pos = list_last_entry(head, typeof(*pos), member);		\
> +	for (list_get_last(pos, head, member);				\
>  	     &pos->member != (head); 					\
>  	     pos = list_prev_entry(pos, member))
>  
> @@ -517,7 +523,7 @@ static inline void list_splice_tail_init(struct list_head *list,
>   * @member:	the name of the list_struct within the struct.
>   */
>  #define list_for_each_entry_safe(pos, n, head, member)			\
> -	for (pos = list_first_entry(head, typeof(*pos), member),	\
> +	for (list_get_first(pos, head, member),				\
>  		n = list_next_entry(pos, member);			\
>  	     &pos->member != (head); 					\
>  	     pos = n, n = list_next_entry(n, member))
> @@ -564,7 +570,7 @@ static inline void list_splice_tail_init(struct list_head *list,
>   * of list entry.
>   */
>  #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
> -	for (pos = list_last_entry(head, typeof(*pos), member),		\
> +	for (list_get_last(pos, head, member),				\
>  		n = list_prev_entry(pos, member);			\
>  	     &pos->member != (head); 					\
>  	     pos = n, n = list_prev_entry(n, member))
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
